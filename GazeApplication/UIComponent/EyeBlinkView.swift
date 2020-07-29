//
//  EyeBlinkView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//瞬きの表示
//UIViewControllerに以下を追加
//var eyeBlinkView: EyeBlinkView!
//var windowWidthCenter: CGFloat!
//let distanceFromCenter: CGFloat = 100
//override func viewDidLoad() {
//    self.windowWidth = self.view.frame.width
//    self.windowHeight = self.view.frame.height
//    updateLookAtPositionText(lookAt: point)
//    drawLookAtPositionLabel()
//}

import UIKit

class EyeBlinkView: UIView {
    var posx: CGFloat = 50
    let posy: CGFloat = 150
    let width: CGFloat = 75
    var height: CGFloat = 75
    var visible = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let oval = UIBezierPath(ovalIn: CGRect(x: self.posx - self.width/2, y: self.posy - self.height/2, width: self.width, height: self.height))
        if self.visible {
            UIColor(red: 0, green: 0, blue: 0.8, alpha: 0.3).setFill()
        } else {
            UIColor(red: 0.8, green: 0, blue: 0, alpha: 0.3).setFill()
        }
        oval.fill()
        UIColor(red: 0, green: 0, blue: 1, alpha: 1).setFill()
        oval.lineWidth = 1.0
        oval.stroke()
    }
}

extension EyeBlinkView {
    func setPosition(posx: CGFloat) {
        self.posx = posx
        self.setNeedsDisplay()
    }
    
    func resetHeight(height: CGFloat) {
        self.height = height
        self.visible = true
        self.setNeedsDisplay()
    }
    
    func invisible() {
        self.visible = false
        self.setNeedsDisplay()
    }
}
