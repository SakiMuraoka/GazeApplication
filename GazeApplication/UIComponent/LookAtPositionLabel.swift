//
//  LookAtPositionLabel.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//注視点数値を表示
//UIViewControllerに以下を追加
//let lookAtPositionLabel = UILabel()
//var point = SIMD3<Float>()
//var windowWidth: CGFloat!
//var windowHeight: CGFloat!
//override func viewDidLoad() {
//瞬きの表示（右目バージョン）
//    self.windowWidthCenter = self.view.bounds.width / 2
//    self.eyeBlinkView = EyeBlinkView(frame: self.view.bounds)
//    self.eyeBlinkView.setPosition(posx: windowWidthCenter + distanceFromCenter)//（右目バージョン）
//    self.eyeBlinkView.setPosition(posx: windowWidthCenter - distanceFromCenter)//（左目バージョン）
//    self.view.addSubview(self.eyeBlinkView)
//}
//以下のSampleViewを使用するViewに変更
//ectention SampleView


import UIKit
import SceneKit

extension SampleView {
    
    func drawLookAtPositionLabel() {
        self.lookAtPositionLabel.frame = CGRect(x: 0, y: self.windowHeight-30, width: self.windowWidth, height: 15)
        self.lookAtPositionLabel.textColor = UIColor.black
        self.lookAtPositionLabel.font = UIFont.systemFont(ofSize: 12)
        self.lookAtPositionLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(self.lookAtPositionLabel)
    }

    func updateLookAtPositionText(lookAt: simd_float3) {
        self.lookAtPositionLabel.text = "x: \(String(format: "%.5f", lookAt[0])), y: \(String(format: "%.5f", lookAt[1])), z: \(String(format: "%.5f", lookAt[2]))"
    }
}
