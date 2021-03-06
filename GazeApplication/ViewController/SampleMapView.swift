//
//  SampleMapView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import ARKit
import EyeTrackKit
import Foundation
import ARVideoKit

class SampleMapView:EyeTrackViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    var eyeTrackController: EyeTrackController!
    var dataController: DataController!
    var lastUpdate: Date = Date()
    
    //データ記録
    let csvModel = CsvModel()
    var participant: String? = "saki"
    var dataLists = [[""]]
    var frameId: Int = 0
    var recordState:Bool = false
    
    var locManager: CLLocationManager!
    var latitudeDelta: CLLocationDegrees!
    var longitudeDelta: CLLocationDegrees!
    var showsUserLocation: Bool!
    var userTrackingMode: MKUserTrackingMode!
    var mapView: MapView!
    var mapInit: Bool = true
    
    var error: Bool = true
    var errorLabel: UILabel!
    
    
    //モード変数
    var mode = 0
    var username = ""
    var mymode = ""
    var myapp = "map"
    
    var eyePointTarget: TestEyePointTarget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "マップ"
        
        //MapViewの表示（今回はマップのみ）
        mapView = MapView(frame: self.view.bounds)
        initMap()
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        //現在地取得の処理
        locManager = CLLocationManager()
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                // 座標の表示
                locManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: self.view.bounds.width, height: 50))
        errorLabel.textAlignment = .center
        errorLabel.isHidden = false
        errorLabel.text = "顔をカメラに写してください"
        self.view.addSubview(errorLabel)
        
        
        eyePointTarget = TestEyePointTarget(frame: self.view.bounds)
        eyePointTarget.center = CGPoint(x: 5*Int(50) - 16, y:Int(50)*10-25)
        eyePointTarget.Resize(radius: self.view.bounds.width/30)
        eyePointTarget.isHidden = true
        self.view.addSubview(eyePointTarget)
        print(self.view.bounds)
        
        if mode == 0 {
            mymode = "demo"
            self.mapView.topY = 100
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }else {
            mymode = "test"
            self.mapView.gazePointer.isHidden = true
            self.eyePointTarget.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    
        if(mode == 1){
            //テストモードでデータ記録の確認
            displayAlert(title: "データの記録", message: "記録を開始してもいいですか？")
        }        
        eyeTrackController = EyeTrackController(device: EyeTrackKit.Device(screenSize: CGSize(width: 0.0757, height: 0.1509), screenPointSize: CGSize(width: 414, height: 896), compensation: CGPoint(x: 0, y: 414)), smoothingRange: 10, blinkThreshold: .infinity, isHidden: false)
        dataController = DataController()
        self.eyeTrackController.onUpdate = { info in
            self.lastUpdate = info!.timestamp
            self.errorLabel.isHidden = true
            self.dataController.add(info: info!, operationType: self.mapView.operationType, operationPoint: self.mapView.operationPosition)
            print(self.mapView.operationType.description + ":" + self.mapView.operationPosition.debugDescription)
            self.mapView.gazePointer.center = CGPoint(x:info!.centerEyeLookAtPoint.x+self.view.bounds.width/2, y:info!.centerEyeLookAtPoint.y+self.view.bounds.height/2)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
//        self.show()
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateChecker), userInfo: nil, repeats: true)
    }
    
    //MARK: - 視線追跡チェッカー
    @objc func updateChecker(){
        let now = Date()
        if(now > Calendar.current.date(byAdding: .nanosecond, value: 100000000, to:self.lastUpdate)!){
            self.errorLabel.isHidden = false
        }
        
        let operationTime = Calendar.current.date(byAdding: .nanosecond, value: 500000000, to: self.mapView.operationTime)!
        if(!self.eyePointTarget.isHidden){
            self.mapView.operationType = "gazeTarget"
            self.mapView.operationPosition = self.eyePointTarget.center
        }else if(now.compare(operationTime) == .orderedDescending){
            self.mapView.operationType = "none"
            self.mapView.operationPosition = CGPoint(x: -1, y: -1)
        }

    }

    
 //MARK: -　マップ処理
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //現在地が変わるたびに，マップの中心を移動
        self.mapView.updateCurrentPos((locations.last?.coordinate)!, mapInit: self.mapInit)
        self.mapInit = false
    }
    
    //マップの初期化
    func initMap() {
        self.latitudeDelta = 0.02
        self.longitudeDelta = 0.02
        // 現在位置表示の有効化
        self.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        self.userTrackingMode = .follow
        
        self.mapView.initMap(latitudeDelta: self.latitudeDelta, longitudeDelta: self.longitudeDelta, showsUserLocation: self.showsUserLocation, userTrackingMode: self.userTrackingMode)
    }
    //MARK:- アラート表示
    func displayAlert(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.recordState = true
            Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(self.screenTimer), userInfo: nil, repeats: false)
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.targetTimer), userInfo: nil, repeats: false)
            self.startRecord()
            self.dataController.start()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        //Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func endAlert(){
        let title = "データの記録が終了しました"
        let message = "OKを押してください"
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(defaultAction)
        //Alertを表示
        present(alert, animated: true, completion: nil)
    }
 //MARK: - タイマー
    @objc func screenTimer(){
        endAlert()
    }
    
    @objc func targetTimer(){
        eyePointTarget.isHidden = true
    }
    
    //MARK: - 画面が閉じる時の処理
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(recordState){
            let now = NSDate()
            let time = timeToString(date: now as Date)
            let fileName = csvModel.convertConditionsToFileName(name: username, conditions: [time, myapp])
            self.dataController.stop()
            //                eyeTrackController.stop(finished: {_ in}, isExport: true) // export video to Photo Library
            self.stopRecord()
//            self.eyeTrackController.stopRecord(finished: { path in print("Video File Path: \(path)") }, isExport: true) // export video to Documents folder
            self.dataController.export(name: fileName, myapp: self.myapp)
            self.dataController.reset()
                recordState = false
        }
    }
    
    //MARK: - ARKitデータの取得
//    override func updateViewWithUpdateAnchor() {
//        if(recordState){
//            self.operationType = mapView.operationType
//            self.operationPosition = mapView.operationPosition
//            let now = NSDate()
//            let time = timeToString(date: now as Date, mode: 1)
//            self.frameId += 1
//            let face_t = eyeTrack.face.transform.columns
//            let right_t = eyeTrack.face.rightEye.node.simdTransform.columns
//            let left_t = eyeTrack.face.leftEye.node.simdTransform.columns
//            let data = [operationPosition.x, operationPosition.y, face_t.0.x, face_t.0.y, face_t.0.z, face_t.0.w,face_t.1.x, face_t.1.y, face_t.1.z, face_t.1.w, face_t.2.x, face_t.2.y, face_t.2.z, face_t.2.w, face_t.3.x, face_t.3.y, face_t.3.z, face_t.3.w, right_t.0.x, right_t.0.y, right_t.0.z, right_t.0.w,right_t.1.x, right_t.1.y, right_t.1.z, right_t.1.w, right_t.2.x, right_t.2.y, right_t.2.z, right_t.2.w, right_t.3.x, right_t.3.y, right_t.3.z, right_t.3.w, left_t.0.x, left_t.0.y, left_t.0.z, left_t.0.w,left_t.1.x, left_t.1.y, left_t.1.z, left_t.1.w, left_t.2.x, left_t.2.y, left_t.2.z, left_t.2.w, left_t.3.x, left_t.3.y, left_t.3.z, left_t.3.w] as [Any]
//            var dataString: [String] = [String(frameId), time, operationType]
//            for i in 0..<data.count {
//                dataString.append(String(format: "%.8f", data[i] as! CVarArg))
//            }
//            //print(dataString)
//            dataLists.append(dataString)
//        }
//    }
    
//    override func updateViewWithScene(withFaceAnchor: ARFaceAnchor){
//        if(withFaceAnchor.isTracked){
//            errorLabel.isHidden = true
//        }else{
//            errorLabel.isHidden = false
//        }
//    }
    //MARK: - 視線の処理(鈴木さん）
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
    //                self.mapView.movePointer(to: CGPoint(x: gazex, y: gazey))
    //            }
    //        }
    //    }
}

