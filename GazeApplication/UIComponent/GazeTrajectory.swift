//
//  GazeTrajectory.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/27.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//


import UIKit

class GazeTrajectory: UIView {
    var x: CGFloat!
    var y: CGFloat!
    var locationOffset: CGFloat!
    var radius: CGFloat!
    var circle: UIBezierPath!
    var circleColor: UIColor!

    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    var length: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.x = frame.width/2
        self.y = frame.height/2
        self.locationOffset = 1
        self.radius = frame.width/15
        self.length = frame.width/8
        self.circleColor = UIColor.gray
        self.backgroundColor = UIColor.clear
        
        self.frame = CGRect(origin: CGPoint(x: self.x - (self.radius + self.locationOffset), y: self.y - (self.radius - self.locationOffset)), size: CGSize(width: self.radius*2+locationOffset*2, height: self.radius*2+locationOffset*2))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // 円
        circle = UIBezierPath(arcCenter: CGPoint(x: self.radius + self.locationOffset, y: self.radius + self.locationOffset), radius: self.radius, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)

        // 内側の色
        circleColor.withAlphaComponent(0.1).setFill()
        // 内側を塗りつぶす
        circle.fill()
        // 線の色
        //circleColor.setStroke()
        // 線の太さ
        //circle.lineWidth = 1.0
        // 線を塗りつぶす
        //circle.stroke()
    }
    
//    func cordinationConvertor(lookAt: [CGFloat]){
//        //スクリーン座標へ変換
//        self.x = CGFloat(lookAt[0]) + self.windowWidth/2
//        self.y = -CGFloat(lookAt[1]) + self.windowHeight/2
//        self.length = self.defaultLength - CGFloat(lookAt[2])
//        print("x: \(String(describing: self.posx)), y: \(String(describing: self.posy)), z: \(String(describing: self.length))")
//        print(x.description + "," + posy.description)
//        self.setNeedsDisplay()
//    }
}

