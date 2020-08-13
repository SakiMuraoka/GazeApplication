//
//  TestEyePointTarget.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/02.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//
import UIKit

class TestEyePointTarget: UIView {
    var x: CGFloat!
    var y: CGFloat!
    var locationOffset: CGFloat!
    var radius: CGFloat!
    var circle: UIBezierPath!
    var circleColor: UIColor!

    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    var mode = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.x = frame.width/2
        self.y = frame.height/2
        self.locationOffset = 1
        if(mode == "demo"){
            self.radius = frame.width/10
        }else{
            self.radius = frame.width/30
        }
        self.circleColor = UIColor.red
        self.backgroundColor = UIColor.clear
         
        self.frame = CGRect(origin: CGPoint(x: self.x - (self.radius + self.locationOffset), y: self.y - (self.radius - self.locationOffset + 300)), size: CGSize(width: self.radius*2+locationOffset*2, height: self.radius*2+locationOffset*2))
    }
     
    required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
    override func draw(_ rect: CGRect) {
        // 円
        circle = UIBezierPath(arcCenter: CGPoint(x: self.radius + self.locationOffset, y: self.radius + self.locationOffset), radius: self.radius, startAngle: 0, endAngle: CGFloat(Double.pi)*2, clockwise: true)

        // 内側の色
        circleColor.withAlphaComponent(0.4).setFill()
        // 内側を塗りつぶす
        circle.fill()
        // 線の色
        circleColor.setStroke()
        // 線の太さ
        circle.lineWidth = 1.0
        // 線を塗りつぶす
        circle.stroke()
    }
}
     
