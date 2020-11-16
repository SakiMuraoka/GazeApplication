//
//  LookAtPosition.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//注視点の表示
//UIViewControllerに以下を追加
//var Looking: LookAtPosition!
//override func viewDidLoad() {
//    self.Looking = LookAtPosition(frame: self.view.bounds)
//    self.view.addSubview(self.Looking)
//}

import UIKit
import SceneKit

class LookAtPosition: UIView {
    var rect: UIBezierPath!
    var posx: CGFloat!
    var posy: CGFloat!
    var length: CGFloat = 30
    let defaultLength: CGFloat = 30
    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.windowWidth = frame.width
        self.windowHeight = frame.height
        self.posx = frame.width/2
        self.posy = frame.height/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.rect = UIBezierPath(ovalIn: CGRect(x: self.posx - self.length/2, y: self.posy - self.length/2, width: self.length, height: self.length))
        UIColor(red: 0.8, green: 0, blue: 0, alpha: 1).setFill()
        self.rect.fill()
        UIColor(red: 1, green: 0, blue: 0, alpha: 1).setFill()
        self.rect.lineWidth = 1.0
        self.rect.stroke()
    }
}

extension LookAtPosition {
    func cordinationConvertor(lookAt: simd_float3){
        self.posx = CGFloat(lookAt[0]) * (self.windowWidth) + self.windowWidth/2
        self.posy = CGFloat(lookAt[1]) * (-self.windowHeight) + self.windowHeight/2
        //self.length = CGFloat(lookAt[2]) * self.defaultLength
        print("x: \(String(describing: self.posx)), y: \(String(describing: self.posy)), z: \(String(describing: self.length))")
        self.setNeedsDisplay()
    }
    
    func getIntersection(camera: SCNVector3, cameraDirection: SCNVector3, facePosition: SCNVector3, lookAt: simd_float3){
        //スクリーン平面の法線ベクトルを計算
        let cameraNorm = SCNVector3Make(cameraDirection.x - camera.x,
                                        cameraDirection.y - camera.y,
                                        cameraDirection.z - camera.z)
        //スクリーンを含む平面と視線ベクトルの交点を求める
        let k = -(cameraNorm.x * (facePosition.x - camera.x)
                + cameraNorm.y * (facePosition.y - camera.y)
                + cameraNorm.z * (facePosition.z - camera.z))
                / (cameraNorm.x * lookAt[0]
                    + cameraNorm.y * lookAt[1]
                    + cameraNorm.z * lookAt[2])
        //スクリーンの中心を始点とするベクトルとして交点を表現
        if k > 0 {
            let intersection = [
                    facePosition.x + k * lookAt[0] - camera.x,
                    facePosition.y + k * lookAt[1] - camera.y,
                    facePosition.z + k * lookAt[2] - camera.z
                ]
            convertMeterToPoint(intersection: intersection)
        }/* else {
            //交点がない時の処理
        }*/
    }
    
    func convertMeterToPoint(intersection: [Float]){
        //face cordinate spaceはメートル単位なのでpointに変換
        let hardWidth = 70.9
        let hardHeight = 143.6
        var milliIntersection = Array<CGFloat>(repeating: 0, count: 3)
        for i in 0..<3 {
            milliIntersection[i] = CGFloat(intersection[i] * 1000)
        }
        let widthRate = self.windowWidth / CGFloat(hardWidth)
        let heightRate = self.windowHeight / CGFloat(hardHeight)
        
        milliIntersection[0] = milliIntersection[0] * widthRate
        milliIntersection[1] = milliIntersection[1] * heightRate
        //print("x: \(String(describing: milliIntersection[0])), y: \(String(describing: milliIntersection[1]))")
        cordinationConvertor(lookAt: milliIntersection)
    }
    
    
    func cordinationConvertor(lookAt: [CGFloat]){
        //スクリーン座標へ変換
        self.posx = CGFloat(lookAt[0]) + self.windowWidth/2
        self.posy = -CGFloat(lookAt[1]) + self.windowHeight/2
        //self.length = self.defaultLength - CGFloat(lookAt[2])
        //print("x: \(String(describing: self.posx)), y: \(String(describing: self.posy)), z: \(String(describing: self.length))")
        self.setNeedsDisplay()
    }
}

