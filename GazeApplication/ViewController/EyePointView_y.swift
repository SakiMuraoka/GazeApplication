//
//  EyePointView_y.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/23.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import EyeTrackKit
import SwiftUI
import ARVideoKit

class EyePointView_y: EyeTrackViewController {
    
    var eyeTrackController: EyeTrackController!
    var dataController: DataController!
    var lastUpdate: Date = Date()
    
    var gridView: GridView!
    
    var error: Bool = true
    var errorLabel: UILabel!
    
    var mode = 0
    var username = ""
    var mymode = ""
    var myapp = "eye"
    
    let csvModel = CsvModel()
    var participant: String? = "saki"
    
    var gazePointer: GazePointer!
    
    var recordState:Bool = false

    //testモードのアニメーションの定数
    let interval = 50
    let offsetX = 16
    let offsetY = 25
    var eyePointTarget: TestEyePointTarget!
    
    var targetView: TargetView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView = GridView(frame: self.view.bounds)
        gridView.backgroundColor = UIColor.white
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: self.view.bounds.width, height: 50))
        errorLabel.textAlignment = .center
        errorLabel.isHidden = false
        errorLabel.text = "顔をカメラに写してください"
        
        
        //視線カーソルの作成と初期化
        gazePointer = GazePointer(frame:self.view.bounds)
        gazePointer.isHidden = true
        
        eyePointTarget = TestEyePointTarget(frame: self.view.bounds)
        eyePointTarget.center = CGPoint(x: 5*Int(interval) - offsetX, y:Int(interval)*10-offsetY)
        eyePointTarget.Resize(radius: self.view.bounds.width/30)
        eyePointTarget.isHidden = true
        
        self.view.addSubview(gridView)
        self.view.addSubview(errorLabel)
        self.view.addSubview(eyePointTarget)
        self.view.addSubview(gazePointer)
        
        if mode == 0 {
            mymode = "demo"
            gazePointer.isHidden = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            displayAlert_(title: "データの観察", message: "モードを選んでください？")
            
        }else {
            mymode = "test"
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            displayAlert(title: "データの記録", message: "記録を開始してもいいですか？")
        }
        
        eyeTrackController = EyeTrackController(device: EyeTrackKit.Device(screenSize: CGSize(width: 0.0757, height: 0.1509), screenPointSize: CGSize(width: 414, height: 896), compensation: CGPoint(x: 0, y: 414)), smoothingRange: 10, blinkThreshold: .infinity, isHidden: false)
        dataController = DataController()
        self.eyeTrackController.onUpdate = { info in
            self.lastUpdate = info!.timestamp
            self.errorLabel.isHidden = true
            self.dataController.add(info: info!, targetPoint: self.targetView.targetPoint)
            self.gazePointer.center = CGPoint(x:info!.centerEyeLookAtPoint.x+self.view.bounds.width/2, y:info!.centerEyeLookAtPoint.y+self.view.bounds.height/2)
        }
        self.initialize(eyeTrack: eyeTrackController.eyeTrack)
//        self.show()
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateChecker), userInfo: nil, repeats: true)
    }
    
    @objc func updateChecker(){
        let now = Date()
        if(now > Calendar.current.date(byAdding: .nanosecond, value: 100000000, to:self.lastUpdate)!){
            self.errorLabel.isHidden = false
        }
    }
    
    //MARK:- アラート表示
    func displayAlert(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        
        let actionChoise = UIAlertAction(title: "OK", style: .default){
            action in
            self.myapp = "eyegaze"
            self.recordState = true
            self.startRecord()
            self.dataController.start()
            self.targetView = TargetView(frame: self.view.bounds)
            self.view.addSubview(self.targetView)
            Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.screenTimer), userInfo: nil, repeats: false)
        }
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.navigationController?.popViewController(animated: true)
        })

        alert.addAction(actionChoise)
        alert.addAction(cancelAction)
        //Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func displayAlert_(title: String, message: String){
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        
        let actionChoise1 = UIAlertAction(title: "データ観察", style: .default){
            action in
            self.myapp = "eyegaze"
            self.eyePointTarget.isHidden = false
            self.moveTarget(fig: self.eyePointTarget)
        }
        
        let actionChoise2 = UIAlertAction(title: "予備実験デモ", style: .default){
            action in
            self.myapp = "eyegaze"
            self.targetView = TargetView(frame: self.view.bounds)
            self.view.addSubview(self.targetView)
        }
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            self.navigationController?.popViewController(animated: true)
        })

        alert.addAction(actionChoise1)
        alert.addAction(actionChoise2)
        alert.addAction(cancelAction)
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
  
    @objc func screenTimer(){
        endAlert()
    }
    
    //MARK: - ターゲットアニメーション
        func moveTarget(fig: UIView) {
            //初期位置をセット
    //        let i = 5
    //        let j = 11
            let timeLimit = 120.0
            testTargetAnimation(fig: fig)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeLimit) {
                self.eyePointTarget.isHidden = true
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        func testTargetAnimation(fig: UIView){
            var i = 0
            var j = 0
            let mini = 2
            let minj = 4
            let maxi = 8
            let maxj = 18

            i = Int.random(in: mini..<maxi + 1)
            j = Int.random(in: minj..<maxj + 1)
            if(myapp != "eyegaze"){
                UIView.animate(withDuration: 2, delay: 0, options:[.curveLinear], animations: {
                    fig.center = CGPoint(x: Int(self.interval)*i - self.offsetX, y: Int(self.interval)*j - self.offsetY)
                }, completion: { finished in
                    self.testTargetAnimation(fig: fig)
                })
            }else{
                UIView.animate(withDuration: 2, delay: 5, options:[.curveLinear], animations: {
                    fig.center = CGPoint(x: Int(self.interval)*i - self.offsetX, y: Int(self.interval)*j - self.offsetY)
                }, completion: { finished in
                    self.testTargetAnimation(fig: fig)
                })
            }
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable sleep screen
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(recordState){
            let now = NSDate()
            let time = timeToString(date: now as Date)
            let fileName = csvModel.convertConditionsToFileName(name: username, conditions: [time, myapp])
            self.dataController.stop()
            //                eyeTrackController.stop(finished: {_ in}, isExport: true) // export video to Photo Library
            self.stopRecord() // export video to Documents folder
            self.dataController.export(name: fileName, myapp: self.myapp)
            self.dataController.reset()
                recordState = false
        }
    }
}


