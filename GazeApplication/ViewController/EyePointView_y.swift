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
import WebKit
import ARVideoKit

class EyePointView_y: EyeTrackViewController_y {

    var gridView: GridView!
    
    var leftEyeView: UIView!
    var rightEyeView: UIView!
    var eyePositionIndicatorView: GazePointer!
    var eyeTrackingPositionView: UIView!
    var eyeTargetPositionXLabel: UILabel!
    var eyeTargetPositionYLabel: UILabel!
    var distanceLabel: UILabel!
    
    var error: Bool = true
    var errorLabel: UILabel!
    
    var mode = 0
    var username = ""
    var mymode = ""
    
    let csvModel = CsvModel()
    var participant: String? = "saki"
    var dataLists = [[""]]
    var frameId: Int = 0
    
    var eyeTrajectryList: [GazeTrajectory] = []
    
    var popupView: PopupView!
    var recordState:Bool = false
    
    //testモードのアニメーションの定数
    let interval = 50
    let offsetX = 16
    let offsetY = 25
    var eyePointTarget: TestEyePointTarget!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView = GridView(frame: self.view.bounds)
        
        eyePositionIndicatorView = GazePointer(frame: self.gridView.bounds)
        leftEyeView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        rightEyeView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        eyeTrackingPositionView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        eyeTargetPositionXLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 40, height: 15))
        eyeTargetPositionYLabel = UILabel(frame: CGRect(x: 60, y: 100, width: 40, height: 15))
        distanceLabel = UILabel(frame: CGRect(x: 110, y: 100, width: 50, height: 15))
        
        errorLabel = UILabel(frame: CGRect(x: 0, y: self.view.center.y, width: self.view.bounds.width, height: 50))
        errorLabel.textAlignment = .center
        errorLabel.isHidden = false
        errorLabel.text = "顔をカメラに写してください"
        
        popupView = PopupView(frame: self.view.bounds)
        popupView.textLabelChange(text: "視線記録を開始しますか")
        popupView.yesButton.addTarget(self, action: #selector(yesButtonClick(_:)), for: UIControl.Event.touchUpInside)
        popupView.noButton.addTarget(self, action: #selector(noButtonClick(_:)), for: UIControl.Event.touchUpInside)
        if(mode == 0){
            popupView.isHidden = true
            recordState = true
        }else{
            eyePositionIndicatorView.isHidden = true
        }
        
        eyePointTarget = TestEyePointTarget(frame: self.view.bounds)
        eyePointTarget.center = CGPoint(x: 2*Int(interval) - offsetX, y:Int(interval)*5-offsetY)
        eyePointTarget.Resize(radius: self.view.bounds.width/30)
        eyePointTarget.isHidden = true
        
        self.view.addSubview(gridView)
        self.view.addSubview(eyePositionIndicatorView)
        self.eyePositionIndicatorView.addSubview(leftEyeView)
        self.eyePositionIndicatorView.addSubview(rightEyeView)
        self.eyePositionIndicatorView.addSubview(eyeTrackingPositionView)
        self.view.addSubview(eyeTargetPositionXLabel)
        self.view.addSubview(eyeTargetPositionYLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(errorLabel)
        self.view.addSubview(popupView)
        self.view.addSubview(eyePointTarget)
        
        moveTarget(fig: eyePointTarget)
        
        if mode == 0 {
            mymode = "demo"
        }else {
            mymode = "test"
        }
    }
    
    @objc func dataButtonClick(_ sender: UIButton){
        let now = NSDate()
        let time = timeToString(date: now as Date, mode: 1)
        self.frameId += 1
        let data = [eyeTrack.lookAtPosition.x, eyeTrack.lookAtPosition.y,]
        var dataString: [String] = [String(frameId), time, mymode]
        for i in 0..<data.count {
            dataString.append(String(format: "%.8f", data[i]))
        }
        //print(dataString)
        dataLists.append(dataString)
    }
    
    @objc func yesButtonClick(_ sender: UIButton){
        recordState = true
        popupView.isHidden = true
        eyePointTarget.isHidden = false
    }
    
    @objc func noButtonClick(_ sender: UIButton){
        popupView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func moveTarget(fig: UIView) {
        //初期位置をセット
        let i = 2 + 1
        let j = 5
        testTargetAnimation(fig: fig, x: i, y: j)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60) {
            self.eyePointTarget.isHidden = true
            self.recordState = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func testTargetAnimation(fig: UIView, x: Int, y: Int){
        var i = x
        var j = y
        let maxi = 8
        let maxj = 16
//        UIView.animate(withDuration: 0, delay: 2, options:[.curveLinear], animations: {
//            fig.center = CGPoint(x: Int(self.interval)*i - self.offsetX, y: Int(self.interval)*j - self.offsetY)
//            if( i < maxi){
//                i += 1
//            }else{
//                i = 2
//                if(j < maxj){
//                    j += 1
//                }else{
//                    j = 5
//                }
//            }
//        }, completion: { finished in
//            self.testTargetAnimation(fig: fig, x: i, y: j)
//        })
        i = Int.random(in: 3..<maxi + 1)
        j = Int.random(in: 5..<maxj + 1)
        UIView.animate(withDuration: 2, delay: 0, options:[.curveLinear], animations: {
            fig.center = CGPoint(x: Int(self.interval)*i - self.offsetX, y: Int(self.interval)*j - self.offsetY)
            if( i < maxi){
                i += 1
            }else{
                i = 2
                if(j < maxj){
                    j += 1
                }else{
                    j = 5
                }
            }
        }, completion: { finished in
            self.testTargetAnimation(fig: fig, x: i, y: j)
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Disable sleep screen
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            let time = formatter.string(from: now as Date)
            let fileName = csvModel.convertConditionsToFileName(name: username, conditions: [time, mymode])
            let data = csvModel.convertFigureListToString(dataLists: dataLists)
            let dataRows = ["frameId", "timestamp", "mode", "lookAtPosition_x", "lookAtPosition_y", "target_x", "target_y", "face_0x","face_0y", "face_0z", "face_0w", "face_1x","face_1y", "face_1z", "face_1w", "face_2x","face_2y", "face_2z", "face_2w", "face_3x","face_3y", "face_3z", "face_3w", "right_0x","right_0y", "right_0z", "right_0w", "right_1x","right_1y", "right_1z", "right_1w", "right_2x","right_2y", "right_2z", "right_2w", "right_3x","right_3y", "right_3z", "right_3w", "left_0x","left_0y", "left_0z", "left_0w", "left_1x","left_1y", "left_1z", "left_1w", "left_2x","left_2y", "left_2z", "left_2w", "left_3x","left_3y", "left_3z", "left_3w"]
            let rowNames = csvModel.convertDataToCSV(list: dataRows)
            csvModel.write(fileName: fileName, rowsName: rowNames, dataList: data)
                recordState = false
    }

    override func updateViewWithUpdateAnchor() {
        if(recordState){
            // update indicator position
             if eyeTrack.lookAtPosition.x < -view.bounds.width/2 + eyePositionIndicatorView.frame.width {
                 eyeTrack.lookAtPosition.x = -view.bounds.width/2 + eyePositionIndicatorView.frame.width
             }else if eyeTrack.lookAtPosition.x > view.bounds.width/2 {
                 eyeTrack.lookAtPosition.x = view.bounds.width/2
             }
            if eyeTrack.lookAtPosition.y < -view.bounds.height/2 + eyePositionIndicatorView.frame.height + 50{
                eyeTrack.lookAtPosition.y = -view.bounds.height/2 + eyePositionIndicatorView.frame.height + 50
            }else if eyeTrack.lookAtPosition.y > view.bounds.height/2{
                eyeTrack.lookAtPosition.y = view.bounds.height/2
            }
            self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: eyeTrack.lookAtPosition.x, y: eyeTrack.lookAtPosition.y)
            if eyeTrack.lookAtPoint.x < 0 {
                self.eyeTargetPositionXLabel.text = "0"
            } else {
                self.eyeTargetPositionXLabel.text = "\(Int(round(eyeTrack.lookAtPoint.x)))"
            }

            if eyeTrack.lookAtPoint.y < 0 {
                self.eyeTargetPositionYLabel.text = "0"
            } else {
                self.eyeTargetPositionYLabel.text = "\(Int(round(eyeTrack.lookAtPoint.y)))"
            }

            // Update distance label value
            self.distanceLabel.text = "\(Int(round(eyeTrack.face.getDistanceToDevice() * 100))) cm"
            if(mode == 0){
                let eyeTrajectry = GazeTrajectory(frame: self.gridView.bounds)
                eyeTrajectry.center = CGPoint(x: eyeTrack.lookAtPosition.x + view.bounds.width/2, y: eyeTrack.lookAtPosition.y + view.bounds.height/2)
                eyeTrajectryList.append(eyeTrajectry)
                if(eyeTrajectryList.count > 30){
                    eyeTrajectryList.first?.removeFromSuperview()
                    eyeTrajectryList.removeFirst()
                }
                self.view.addSubview(eyeTrajectryList[eyeTrajectryList.count - 1])
            }
            let target = eyePointTarget.layer.presentation()?.position
            let now = NSDate()
            let time = timeToString(date: now as Date, mode: 1)
            self.frameId += 1
            let face_t = eyeTrack.face.transform.columns
            let right_t = eyeTrack.face.rightEye.node.simdTransform.columns
            let left_t = eyeTrack.face.leftEye.node.simdTransform.columns
            let data = [eyePositionIndicatorView.center.x + eyeTrack.lookAtPosition.x, eyePositionIndicatorView.center.y + eyeTrack.lookAtPosition.y ,target!.x, target!.y, face_t.0.x, face_t.0.y, face_t.0.z, face_t.0.w,face_t.1.x, face_t.1.y, face_t.1.z, face_t.1.w, face_t.2.x, face_t.2.y, face_t.2.z, face_t.2.w, face_t.3.x, face_t.3.y, face_t.3.z, face_t.3.w, right_t.0.x, right_t.0.y, right_t.0.z, right_t.0.w,right_t.1.x, right_t.1.y, right_t.1.z, right_t.1.w, right_t.2.x, right_t.2.y, right_t.2.z, right_t.2.w, right_t.3.x, right_t.3.y, right_t.3.z, right_t.3.w, left_t.0.x, left_t.0.y, left_t.0.z, left_t.0.w,left_t.1.x, left_t.1.y, left_t.1.z, left_t.1.w, left_t.2.x, left_t.2.y, left_t.2.z, left_t.2.w, left_t.3.x, left_t.3.y, left_t.3.z, left_t.3.w] as [Any]
            var dataString: [String] = [String(frameId), time, mymode]
            for i in 0..<data.count {
                dataString.append(String(format: "%.8f", data[i] as! CVarArg))
            }
            //print(dataString)
            dataLists.append(dataString)
        }
    }
    
    override func updateViewWithScene(withFaceAnchor: ARFaceAnchor){
        if(withFaceAnchor.isTracked){
            errorLabel.isHidden = true
        }else{
            errorLabel.isHidden = false
        }
    }
}


extension EyePointView_y {
    func timeToString(date: Date, mode: Int) -> String {
        let format = DateFormatter()
        switch mode {
        case 0:
                format.dateFormat = "MM/dd/HH:mm"
        case 1:
                format.dateFormat = "HH:mm:ss.SSS"
        default:
            break
        }
        return format.string(from: date)
    }
}


