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
    
    var recordButton: UIButton!
    var recordState:Bool = false
    
    var mode = ""
    var username = ""
    
    var dataButton: UIButton!
    let csvModel = CsvModel()
    var participant: String? = "saki"
    var dataLists = [[""]]
    var frameId: Int = 0
    
    var eyeTrajectryList: [GazeTrajectory] = []


//    @IBAction func onClickRecord(_ sender: Any) {
//        self.startRecord()
//    }
//
//    @IBAction func onClickStop(_ sender: Any) {
//        self.stopRecord()
//    }

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
        
        recordButton = UIButton(type: .system)
        recordButton.setTitle("記録開始", for: .normal)
        recordButton.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        recordButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        recordButton.setTitleColor(UIColor.white, for: .normal)
        recordButton.layer.cornerRadius = recordButton.bounds.midY
        recordButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        recordButton.backgroundColor = UIColor.gray
        recordButton.addTarget(self, action: #selector(recordButtonClick(_:)), for: UIControl.Event.touchUpInside)
        if(mode == "demo"){
            recordButton.isHidden = true
        }
        
        dataButton = UIButton(type: .system)
        dataButton.setTitle("データ追加", for: .normal)
        dataButton.sizeToFit()
        dataButton.center = CGPoint(x: self.view.center.x, y: self.view.bounds.height - 100)
        dataButton.addTarget(self, action: #selector(dataButtonClick(_:)), for: UIControl.Event.touchUpInside)
        if(mode == "test"){
            dataButton.isHidden = true
        }
        
        self.view.addSubview(gridView)
        self.view.addSubview(eyePositionIndicatorView)
        self.eyePositionIndicatorView.addSubview(leftEyeView)
        self.eyePositionIndicatorView.addSubview(rightEyeView)
        self.eyePositionIndicatorView.addSubview(eyeTrackingPositionView)
        self.view.addSubview(eyeTargetPositionXLabel)
        self.view.addSubview(eyeTargetPositionYLabel)
        self.view.addSubview(distanceLabel)
        self.view.addSubview(errorLabel)
        self.view.addSubview(dataButton)
        self.view.addSubview(recordButton)
        
    }
    
    @objc func dataButtonClick(_ sender: UIButton){
        let now = NSDate()
        let time = timeToString(date: now as Date)
        self.frameId += 1
        let data = [eyeTrack.lookAtPosition.x, eyeTrack.lookAtPosition.y,]
        var dataString: [String] = [String(frameId), time, mode]
        for i in 0..<data.count {
            dataString.append(String(format: "%.8f", data[i]))
        }
        //print(dataString)
        dataLists.append(dataString)
    }
    
    @objc func recordButtonClick(_ sender: UIButton){
        recordState = true
        recordButton.isHidden = true
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
        let fileName = csvModel.convertConditionsToFileName(name: username, conditions: [time, "gaze"])
        let data = csvModel.convertFigureListToString(dataLists: dataLists)
        let dataRows = ["frameId", "timestamp", "mode", "lookAtPosition_x", "lookAtPosition_y",]
        let rowNames = csvModel.convertDataToCSV(list: dataRows)
        csvModel.write(fileName: fileName, rowsName: rowNames, dataList: data)
        recordState = false
    }

    override func updateViewWithUpdateAnchor() {
        if(recordState){
            let now = NSDate()
            let time = timeToString(date: now as Date)
            self.frameId += 1
            let data = [eyeTrack.lookAtPosition.x, eyeTrack.lookAtPosition.y,]
            var dataString: [String] = [String(frameId), time, mode]
            for i in 0..<data.count {
                dataString.append(String(format: "%.8f", data[i]))
            }
            //print(dataString)
            dataLists.append(dataString)
        }
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
        
        let eyeTrajectry = GazeTrajectory(frame: self.gridView.bounds)
        eyeTrajectry.center = CGPoint(x: eyeTrack.lookAtPosition.x + view.bounds.width/2, y: eyeTrack.lookAtPosition.y + view.bounds.height/2)
        eyeTrajectryList.append(eyeTrajectry)
        if(eyeTrajectryList.count > 30){
            eyeTrajectryList.first?.removeFromSuperview()
            eyeTrajectryList.removeFirst()
        }
        self.view.addSubview(eyeTrajectryList[eyeTrajectryList.count - 1])

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
    func timeToString(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        return format.string(from: date)
    }
}


