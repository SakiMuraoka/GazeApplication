//
//  HomeView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import EyeTrackKit
import SwiftUI

class HomeView: EyeTrackViewController {
    
    var eyeTrackController: EyeTrackController!
    var dataController: DataController!
    var lastUpdate: Date = Date()
    
    var iconView: IconView!
    
    var mode = 0
    var username = ""
    var mymode = ""
    var myapp = "home"
    
    let csvModel = CsvModel()
    var participant: String? = "saki"
    
    var errorLabel: UILabel!
    var eyePointTarget: TestEyePointTarget!
    
    var recordState:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconView = IconView(frame: self.view.bounds)
        self.view.addSubview(iconView)
        
//        iconView.mapIcon.addTarget(self,action: #selector(self.tapButton(_ :)),for: .touchUpInside)
//        iconView.galleryIcon.addTarget(self,action: #selector(self.tapButton(_ :)),for: .touchUpInside)
//        iconView.browserIcon.addTarget(self,action: #selector(self.tapButton(_ :)),for: .touchUpInside)
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: self.view.bounds.width, height: 50))
        errorLabel.textAlignment = .center
        errorLabel.isHidden = false
        errorLabel.text = "顔をカメラに写してください"
        
        eyePointTarget = TestEyePointTarget(frame: self.view.bounds)
        eyePointTarget.center = CGPoint(x: 5*Int(50) - 16, y:Int(50)*10-25)
        eyePointTarget.Resize(radius: self.view.bounds.width/30)
        
        self.view.addSubview(errorLabel)
        self.view.addSubview(eyePointTarget)
        
        
        self.title = "ホーム"
        
        if mode == 0 {
            mymode = "demo"
            self.iconView.gazePointer.isHidden = false
            eyePointTarget.isHidden = true
            self.iconView.iconShuffle()
        }else {
            mymode = "test"
            self.iconView.gazePointer.isHidden = true
        }
        
        //テストモードでデータ記録の確認
        if(mode == 1){
            displayAlert(title: "データの記録", message: "記録を開始してもいいですか？")
        }else{

        }
        eyeTrackController = EyeTrackController(device: EyeTrackKit.Device(screenSize: CGSize(width: 0.0757, height: 0.1509), screenPointSize: CGSize(width: 414, height: 896), compensation: CGPoint(x: 0, y: 414)), smoothingRange: 10, blinkThreshold: .infinity, isHidden: false)
        dataController = DataController()
        self.eyeTrackController.onUpdate = { info in
            self.lastUpdate = info!.timestamp
            self.errorLabel.isHidden = true
            self.dataController.add(info: info!, operationType: self.iconView.operationType, operationPoint: self.iconView.operationPosition)
            self.iconView.gazePointer.center = CGPoint(x:info!.centerEyeLookAtPoint.x+self.view.bounds.width/2, y:info!.centerEyeLookAtPoint.y+self.view.bounds.height/2)
            print(self.iconView.operationPosition)
        }
    
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
//        self.show()
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateChecker), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.resetData), userInfo: nil, repeats: true)
    }
    
    @objc func updateChecker(){
        let now = Date()
        if(now > Calendar.current.date(byAdding: .nanosecond, value: 100000000, to:self.lastUpdate)!){
            self.errorLabel.isHidden = false
        }
    }
    @objc func resetData(){
        if(!self.eyePointTarget.isHidden){
            self.iconView.operationType = "gazeTarget"
            self.iconView.operationPosition = self.eyePointTarget.center
        }
        self.iconView.operationType = "none"
        self.iconView.operationPosition = CGPoint()
    }
    
    //MARK: - 画面を閉じるときの処理（ファイル作成）
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(recordState){
            let now = NSDate()
            let time = timeToString(date: now as Date)
            let fileName = csvModel.convertConditionsToFileName(name: username, conditions: [time, myapp])
            self.dataController.stop()
            //                eyeTrackController.stop(finished: {_ in}, isExport: true) // export video to Photo Library
            self.eyeTrackController.stopRecord(finished: { path in print("Video File Path: \(path)") }, isExport: false) // export video to Documents folder
            self.dataController.export(name: fileName, myapp: self.myapp)
            self.dataController.reset()
                recordState = false
        }
    }

    
    //MARK:- アラート表示
    func displayAlert(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        
        let actionChoise1 = UIAlertAction(title: "OK", style: .default){
            action in
            print("OK")
            self.recordState = true
            self.timerStart()
            self.eyeTrackController.startRecord()
            self.dataController.start()
        }

        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(actionChoise1)
        alert.addAction(cancelAction)
        //Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - タイマー
    func timerStart(){
        self.iconView.operationType = "gazeTarget"
        self.iconView.operationPosition = self.eyePointTarget.center
        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(self.screenTimer), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.targetTimer), userInfo: nil, repeats: false)
    }
    @objc func screenTimer(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func targetTimer(){
        self.eyePointTarget.isHidden = true
        self.iconView.iconShuffle()
    }
    //MARK: - ボタンタップ
    
//    @objc func tapButton(_ sender: UIButton){
//        if mode == 0{
//            switch sender.accessibilityIdentifier{
//            case "map":
//                let nextView = self.storyboard!.instantiateViewController(withIdentifier: "mapView")
//                self.navigationController?.pushViewController(nextView, animated: true)
//                break
//            case "gallery":
//                let nextView = self.storyboard!.instantiateViewController(withIdentifier: "galleryView")
//                self.navigationController?.pushViewController(nextView, animated: true)
//                break
//            case "browser":
//                let nextView = self.storyboard!.instantiateViewController(withIdentifier: "browserView")
//                self.navigationController?.pushViewController(nextView, animated: true)
//                break
//            default:
//                break
//            }
//        }
//    }
    
    //MARK: - 視線の処理
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        resetTracking()
//    }
//
//    func resetTracking() {
//        let configration = ARFaceTrackingConfiguration()    //front-facingカメラを使ったAR
//        self.session.run(configration, options: [.resetTracking, .removeExistingAnchors])   //ARSessionの開始
//    }
//
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//        frame.anchors.forEach { anchor in
//            guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }
//
//            let faceNode = SCNNode()                        //faceNodeの作成
//            faceNode.simdTransform = faceAnchor.transform   //変換行列の設定
//
//            let point = faceAnchor.lookAtPoint   //ユーザが見ている点
//
//            let cameraTransform = frame.camera.transform    //カメラの位置と向きの情報
//
//            //world cordinationにおけるカメラの座標（絶対(0,0,0))
//            let cameraPosition = SCNVector3Make(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
//
//
//            //face cordinate spaceにおけるカメラの座標（のはず）
//            let cameraOnFaceNode = faceNode.convertPosition(cameraPosition, from: nil)
//
//            //カメラの向き
//            let cameraAngle = SCNVector3Make(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
//            let cameraAngleFaceNode = faceNode.convertPosition(cameraAngle, to: nil)
//
//            let leftEye = faceAnchor.leftEyeTransform
//            let rightEye = faceAnchor.rightEyeTransform
//            let eyesCenter = SCNVector3Make(
//                            (leftEye.columns.3.x + rightEye.columns.3.x)/2,
//                            (leftEye.columns.3.y + rightEye.columns.3.y)/2,
//                            (leftEye.columns.3.z + rightEye.columns.3.z)/2)
//
//
//            //スクリーン平面の法線ベクトルを計算
//            let cameraNorm = SCNVector3Make(cameraAngleFaceNode.x - cameraOnFaceNode.x,
//                                            cameraAngleFaceNode.y - cameraOnFaceNode.y,
//                                            cameraAngleFaceNode.z - cameraOnFaceNode.z)
//            //スクリーンを含む平面と視線ベクトルの交点を求める
//            let k = -(cameraNorm.x * (eyesCenter.x - cameraOnFaceNode.x)
//                    + cameraNorm.y * (eyesCenter.y - cameraOnFaceNode.y)
//                    + cameraNorm.z * (eyesCenter.z - cameraOnFaceNode.z))
//                    / (cameraNorm.x * point[0]
//                        + cameraNorm.y * point[1]
//                        + cameraNorm.z * point[2])
//            //スクリーンの中心を始点とするベクトルとして交点を表現
//            if k > 0 {
//                let intersection = [
//                        eyesCenter.x + k * point[0] - cameraOnFaceNode.x,
//                        eyesCenter.y + k * point[1] - cameraOnFaceNode.y,
//                        eyesCenter.z + k * point[2] - cameraOnFaceNode.z
//                    ]
//
//                let hardWidth = 70.9
//                let hardHeight = 143.6
//                var milliIntersection = Array<CGFloat>(repeating: 0, count: 3)
//                for i in 0..<3 {
//                    milliIntersection[i] = CGFloat(intersection[i] * 1000)
//                }
//                let widthRate = self.windowWidth / CGFloat(hardWidth)
//                let heightRate = self.windowHeight / CGFloat(hardHeight)
//
//                milliIntersection[0] = milliIntersection[0] * widthRate
//                milliIntersection[1] = milliIntersection[1] * heightRate
//                //print("x: \(String(describing: milliIntersection[0])), y: \(String(describing: milliIntersection[1]))")
//                //gazePointer.cordinationConvertor(lookAt: milliIntersection)
//                let gazex = CGFloat(milliIntersection[0]) + self.windowWidth/2
//                let gazey = -CGFloat(milliIntersection[1]) + self.windowHeight/2
//                self.iconView.movePointer(to: CGPoint(x: gazex, y: gazey))
//            }
//        }
//    }
    //---------------------------------
}
