//
//  FaceDirectionArrowView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//顔の向きの矢印を表示
//UIViewControllerに以下を追加
//var faceDirectionArrow: FaceDirectionArrowView!
//override func viewDidLoad() {
//    self.faceDirectionArrow = FaceDirectionArrowView(frame: self.view.bounds)
//    self.view.addSubview(self.faceDirectionArrow)
//}

import UIKit

class FaceDirectionArrowView: UIView {
    var x: CGFloat = 0.1
    var y: CGFloat = 0.1
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let w = rect.width/2
        let h = rect.height/2
        let lx = self.x * w
        let ly = self.y * h
        
        let arrow = UIBezierPath();
        arrow.move(to: CGPoint(x: w, y: h))
        let head: CGPoint = CGPoint(x: w + lx, y: h + ly)
        arrow.addLine(to: head)
        arrow.close()
        UIColor.black.setStroke()
        arrow.lineWidth = 2
        arrow.stroke()
        
        let arrowHeadSize = CGFloat(sqrt(lx * lx + ly * ly) / 3)
        let theta: CGFloat = 210 * CGFloat.pi / 180
        let alpha: CGFloat = atan2(ly, lx)
        
        let arrowHead = UIBezierPath();
        arrowHead.move(to: head)
        arrowHead.addLine(to: CGPoint(x: head.x + arrowHeadSize * cos(theta - alpha), y: head.y - arrowHeadSize * sin(theta - alpha)))
        arrowHead.addLine(to: CGPoint(x: head.x + arrowHeadSize * cos(theta + alpha), y: head.y + arrowHeadSize * sin(theta + alpha)))
        arrowHead.close()
        UIColor.black.setStroke()
        arrowHead.lineWidth = 2
        arrowHead.stroke()
    }
    
    func setParams(x: CGFloat, y: CGFloat) {
        self.x = -x
        self.y = y
        self.setNeedsDisplay()
    }
}
