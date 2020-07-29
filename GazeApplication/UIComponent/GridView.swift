//
//  GridView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/20.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//グリッド線の表示
//UIViewControllerに以下を追加
//override func viewDidLoad(){
//    let gridView = GridView(frame: self.view.bounds)
//    self.view.addSubview(gridView)
//}

import UIKit
class GridView: UIView {
    let interval: CGFloat = 50//格子の幅
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear//背景色
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
            let w = rect.width/2
            let h = rect.height/2
            
            var horizontalLines: [UIBezierPath] = [newLine(from: CGPoint(x: 0, y:h), to: CGPoint(x: 2*w, y:h))]
            var verticalLines: [UIBezierPath] = [newLine(from: CGPoint(x: w, y:0), to: CGPoint(x: w, y:2*h))]
            
            for i in 1...Int(h/interval) {
                var from = CGPoint(x: 0, y:h + CGFloat(i) * interval)
                var to = CGPoint(x: 2*w, y:h + CGFloat(i) * interval)
                horizontalLines += [newLine(from: from, to: to)]
                from = CGPoint(x: 0, y:h - CGFloat(i) * interval)
                to = CGPoint(x: 2*w, y:h - CGFloat(i) * interval)
                horizontalLines += [newLine(from: from, to: to)]
            }
            
            for i in 1...Int(w/interval) {
                var from = CGPoint(x: w + CGFloat(i) * interval, y:0)
                var to = CGPoint(x: w + CGFloat(i) * interval, y:2*h)
                verticalLines += [newLine(from: from, to: to)]
                from = CGPoint(x: w - CGFloat(i) * interval, y:0)
                to = CGPoint(x: w - CGFloat(i) * interval, y:2*h)
                verticalLines += [newLine(from: from, to: to)]
            }
    }
    
    func newLine(from: CGPoint, to: CGPoint) -> UIBezierPath{
        let line = UIBezierPath();
        line.move(to: from)
        line.addLine(to: to)
        line.close()
        UIColor.gray.setStroke()//ラインの色
        line.lineWidth = 1
        line.stroke()
        return line
    }

}

