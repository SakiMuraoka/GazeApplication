//
//  targetView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2021/01/02.
//  Copyright © 2021 村岡沙紀. All rights reserved.
//

import UIKit

class TargetView: UIView, UIGestureRecognizerDelegate {
    // UIButtonを継承した独自クラス
    class iconButton: UIButton{
        let iconNumber:Int
        init(iconNumber: Int, frame:CGRect){
            self.iconNumber = iconNumber
            super.init(frame:frame)
        }
        required init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

    var iconNumX = 3
    var iconNumY = 3
    var heightOffset: CGFloat = 35
    var margin:CGFloat = 10
    
    var rightArray: [Int] = []
    var iconArray: [iconButton] = []
    var targetPoint = CGPoint(x: -1, y: -1)
    
    
    var tapGesture: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        
        let iconSize: CGFloat = 60
        let marginX: CGFloat = ((frame.width-margin*2)-iconSize*CGFloat(iconNumX))/CGFloat(iconNumX-1)
        let marginY: CGFloat = ((frame.height-heightOffset-margin*2)-iconSize*CGFloat(iconNumY))/CGFloat(iconNumY-1)
        super.init(frame: frame)
//        array.shuffle()
        var iconCount = 0
        for x in 0...iconNumX-1{
            for y in 0...iconNumY-1{
                let iconX = CGFloat(x)*(iconSize + marginX) + margin
                let iconY = CGFloat(y)*(iconSize + marginY) + heightOffset + margin
            //位置を変えながらボタンを作る
                let icon : UIButton = iconButton(
                    iconNumber: iconCount,
                    frame:CGRect(x: iconX, y: iconY, width: iconSize, height: iconSize))
            //ボタンを押したときの動作
                icon.addTarget(self, action: #selector(pushed), for: .touchUpInside)
                icon.layer.cornerRadius = 15.0
                icon.isHidden = true
                icon.backgroundColor = UIColor.systemGray2
                iconCount += 1
                icon.setTitle("+", for: .normal)
                iconArray.append(icon as! TargetView.iconButton)
                //画面に追加
                self.addSubview(icon)
            }
        }
        iconArray[4].isHidden = false
    }
    
    @objc func iconShuffle(_ sender: Timer){
        targetPoint = CGPoint(x: -1, y: -1)
        let btn = sender.userInfo as! iconButton
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        btn.isHidden = true
        btn.backgroundColor = UIColor.systemGray2
        var rnd = -1
        let iconNum = iconNumX * iconNumY
        while btn.iconNumber == rnd || rnd == -1 {
            rnd = Int.random(in: 0..<iconNum)
        }
        iconArray[rnd].isHidden = false
        iconArray[rnd].isEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    //MARK: - ボタン
    @objc func pushed(mybtn : iconButton){
        targetPoint = CGPoint(x: mybtn.center.x+mybtn.frame.width/2, y: mybtn.center.y+mybtn.frame.height/2)
        mybtn.backgroundColor = UIColor.systemGreen
        mybtn.isEnabled = false
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector( iconShuffle), userInfo: mybtn, repeats: false)
    }
    
    //MARK: - タップ
    @objc func tapAction(gesture: UITapGestureRecognizer) {
        targetPoint = gesture.location(in: self)
        targetPoint = CGPoint(x: self.targetPoint.x + 20, y: self.targetPoint.y + 20)
    }

}
