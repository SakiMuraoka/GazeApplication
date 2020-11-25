//
//  AnimationView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/17.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class AnimationView: UIViewController {
    var iconView: IconView!
    var gridView: GridView!
    var mapView: MapView!
    
    var fileNameLabel: UILabel!
    var slider: UISlider!
    var sliderLabel: UILabel!
    
    var fileName: String = ""
    var myapp: String = ""
    
    var csvLines: [String] = []
    var csvData: [[String]] = []
    
    //testモードのアニメーションの定数
    let interval = 50
    var target: TestEyePointTarget!
    var eyePoint: TestEyePointTarget!
    var operationLabel: UILabel!
    var offsetX: Double = 0.0
    var offsetY: Double = 0.0
    
    var operationTrajectryList: [TestEyePointTarget] = []
    var eyeTrajectryList: [TestEyePointTarget] = []
    
    var animationStop = false
    
    var i  = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = NSHomeDirectory() + "/Documents/" + fileName
        
        do {
            let csvString = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            csvLines = csvString.components(separatedBy: .newlines)
            csvLines.removeLast()         //これを追加
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }

        for csvLine in csvLines {
            csvData.append( csvLine.components(separatedBy: ","))
        }
        
        iconView = IconView(frame: self.view.bounds)
        gridView = GridView(frame: self.view.bounds)
        mapView = MapView(frame: self.view.bounds)
        
        target = TestEyePointTarget(frame: self.view.bounds)
        target.Resize(radius: self.view.bounds.width/30)
        
        let fileName_ = fileName.replacingOccurrences(of:".csv", with:"")
        let nameDetails = fileName_.components(separatedBy: "_")
        self.myapp = nameDetails[2]
        
        operationLabel = UILabel()
        operationLabel.backgroundColor = UIColor.white

        if(myapp == "eye" || myapp == "eyegaze"){
            target.center = CGPoint(x: Double(csvData[1][37]) ?? Double(self.view.bounds.center.x), y: Double(csvData[1][38]) ?? Double(self.view.bounds.center.y))
            self.view.addSubview(gridView)
        }else if(myapp == "home"){
            self.iconView.gazePointer.isHidden = true
            self.view.addSubview(iconView)
            target.center = CGPoint(x: Double(csvData[1][38]) ?? Double(self.view.bounds.center.x), y: Double(csvData[1][39]) ?? Double(self.view.bounds.center.y))
            operationLabel.text = csvData[1][37]
            operationLabel.sizeToFit()
            operationLabel.center = CGPoint(x: target.center.x, y: target.center.y + 30)
        }else{
            self.mapView.gazePointer.isHidden = true
            self.view.addSubview(mapView)
            target.center = CGPoint(x: Double(csvData[1][38]) ?? Double(self.view.bounds.center.x), y: Double(csvData[1][39]) ?? Double(self.view.bounds.center.y))
            operationLabel.text = csvData[1][37]
            operationLabel.sizeToFit()
            operationLabel.center = CGPoint(x: target.center.x, y: target.center.y + 30)
        }
        self.view.addSubview(target)
        var TotaleyePointX = 0.0
        var TotaleyePointY = 0.0
        var totalNum = 300
        if(csvData.count < totalNum){
            totalNum = csvData.count-1
        }
        for i in 1...totalNum{
            TotaleyePointX += ((Double(csvData[i][31]) ?? 0.0) + Double(self.view.bounds.width/2))
            TotaleyePointY += ((Double(csvData[i][32]) ?? 0.0) + Double(self.view.bounds.height/2))
        }
        let eyePointX = TotaleyePointX/totalNum
        let eyePointY = TotaleyePointY/totalNum
        offsetX = Double(self.view.bounds.width/2) - eyePointX
        offsetY = Double(self.view.bounds.height/2) - eyePointY
        eyePoint = TestEyePointTarget(frame: self.view.bounds)
        eyePoint.Resize(radius: self.view.bounds.width/30)
        eyePoint.circleColor = UIColor.gray
        eyePoint.center = CGPoint(x: eyePointX + offsetX, y: eyePointY + offsetY)
        eyePoint.center = CGPoint(x: self.view.bounds.center.x, y: self.view.bounds.center.y)
        self.view.addSubview(eyePoint)
        self.view.addSubview(operationLabel)
        
        
        fileNameLabel = UILabel(frame: CGRect(x: 0, y: 100, width: 0, height: 0))
        fileNameLabel.text = fileName
        fileNameLabel.sizeToFit()
        fileNameLabel.backgroundColor = UIColor.white
        self.view.addSubview(fileNameLabel)

        
        slider = UISlider(frame: CGRect(x: 10, y: self.view.bounds.height-100, width: self.view.bounds.width - 20, height: 20))
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        slider.minimumValue = Float(i)
        slider.maximumValue = Float(csvData.count-1);
        slider.value = Float(i)
        self.view.addSubview(slider)
        
        sliderLabel = UILabel()
        sliderLabel.text = csvData[i][0]
        sliderLabel.sizeToFit()
        sliderLabel.center = CGPoint(x: self.view.bounds.center.x, y: self.view.bounds.height-70)
        sliderLabel.backgroundColor = UIColor.white
        self.view.addSubview(sliderLabel)
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        
        moveTarget(myapp: self.myapp)
    }
    @objc func updateSlider(){
        slider.value = Float(self.i)
        sliderLabel.text = csvData[i][0]
        sliderLabel.sizeToFit()
    }
    @objc func sliderChanged(_ sender: UISlider){
        self.i = Int(sender.value)
//        self.testTargetAnimation(fig1: target, fig2: eyePoint, data: self.csvData[self.i])
    }
    func moveTarget(myapp: String) {
        testTargetAnimation(myapp: myapp, data: csvData[i])
    }
    func testTargetAnimation(myapp: String, data: [String]){
        let duration = (Double(data[0]) ?? 0) - (Double(self.csvData[self.i-1][0]) ?? 0)
        if(myapp == "eye" || myapp == "eyegaze"){
            UIView.animate(withDuration: 0, delay: duration*0.0001, options:[.curveLinear], animations: {
                self.target.center = CGPoint(x: Double(data[37]) ?? 0.0, y: Double(data[38]) ?? 0.0)
                let eyePointX = (Double(data[31]) ?? 0.0) + Double(self.view.bounds.width/2)
                let eyePointY = (Double(data[32]) ?? 0.0) + Double(self.view.bounds.height/2)
                self.eyePoint.center = CGPoint(x: eyePointX + self.offsetX, y: eyePointY + self.offsetY)
            }, completion: { finished in
                self.i += 1
                if(self.i >= self.csvData.count-1){
                    self.i = 2
                }
                if(!self.animationStop){
                    self.testTargetAnimation(myapp: myapp, data: self.csvData[self.i])
                }
            })
        }else{
            UIView.animate(withDuration: 0, delay: duration*0.0001, options:[.curveLinear], animations: {
                self.target.center = CGPoint(x: Double(data[38]) ?? 0.0, y: Double(data[39]) ?? 0.0)
                let eyePointX = (Double(data[31]) ?? 0.0) + Double(self.view.bounds.width/2)
                let eyePointY = (Double(data[32]) ?? 0.0) + Double(self.view.bounds.height/2)
                self.eyePoint.center = CGPoint(x: eyePointX + self.offsetX, y: eyePointY + self.offsetY)
                self.operationLabel.text = data[37]
                self.operationLabel.sizeToFit()
                self.operationLabel.center = CGPoint(x: self.target.center.x, y: self.target.center.y + 30)
            }, completion: { finished in
                self.i += 1
                if(self.i >= self.csvData.count-1){
                    self.i = 2
                }
                if(!self.animationStop){
                    self.testTargetAnimation(myapp: myapp, data: self.csvData[self.i])
                }
            })
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.animationStop = true
    }
    func addTrajectryList(){
        let Copy_target = TestEyePointTarget(frame: self.view.bounds)
        Copy_target.Resize(radius: self.view.bounds.width/30)
        Copy_target.center = self.target.center
        let Copy_eyePoint = TestEyePointTarget(frame: self.view.bounds)
        Copy_eyePoint.Resize(radius: self.view.bounds.width/30)
        Copy_eyePoint.circleColor = UIColor.gray
        Copy_eyePoint.center = self.eyePoint.center
        self.operationTrajectryList.append(Copy_target)
//        self.view.addSubview(Copy_target)
//        if(self.operationTrajectryList.count > 50){
//            self.operationTrajectryList[0].removeFromSuperview()
//            self.operationTrajectryList.remove(at: 0)
//            self.operationTrajectryList.append(Copy_target)
//        }else{
//            self.operationTrajectryList.append(Copy_target)
//        }
//        if(self.eyeTrajectryList.count > 50){
//            self.eyeTrajectryList[0].removeFromSuperview()
//            self.eyeTrajectryList.remove(at: 0)
//            self.eyeTrajectryList.append(Copy_eyePoint)
//        }else{
//            self.eyeTrajectryList.append(Copy_eyePoint)
//        }
//        self.view.addSubview(eyeTrajectryList[eyeTrajectryList.count - 1])
    }

}
