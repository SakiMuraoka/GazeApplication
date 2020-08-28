//
//  ViewController.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class SampleView: UIViewController {
    var Looking: LookAtPosition!
    
    let lookAtPositionLabel = UILabel()
    var point = SIMD3<Float>()
    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    
    var eyeBlinkView: EyeBlinkView!
    var windowWidthCenter: CGFloat!
    let distanceFromCenter: CGFloat = 100
    
    var faceDirectionArrow: FaceDirectionArrowView!
    
    var iconView: IconView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //グリッド線の表示
        let gridView = GridView(frame: self.view.bounds)
        //self.view.addSubview(gridView)
        //注視点の表示
        self.Looking = LookAtPosition(frame: self.view.bounds)
        //self.view.addSubview(self.Looking)
        //注視点数値の表示
        self.windowWidth = self.view.frame.width
        self.windowHeight = self.view.frame.height
        updateLookAtPositionText(lookAt: point)
        //drawLookAtPositionLabel()
        //瞬きの表示（右目バージョン）
        self.windowWidthCenter = self.view.bounds.width / 2
        self.eyeBlinkView = EyeBlinkView(frame: self.view.bounds)
        self.eyeBlinkView.setPosition(posx: windowWidthCenter + distanceFromCenter)
        //self.view.addSubview(self.eyeBlinkView)
        //顔の向きの矢印を表示
        self.faceDirectionArrow = FaceDirectionArrowView(frame: self.view.bounds)
        //self.view.addSubview(self.faceDirectionArrow)
        //iconViewの表示
        self.iconView = IconView(frame: self.view.bounds)
        self.view.addSubview(iconView)
    }
}

