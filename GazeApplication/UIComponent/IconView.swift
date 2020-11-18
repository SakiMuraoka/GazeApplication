//
//  IconView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class IconView: UIView {
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

    
    let gazePointer: GazePointer!
    var rightArray: [Int] = []
    var iconArray: [iconButton] = []
    var array = [Int](1...24)
    var operationType = "none"
    var operationPosition = CGPoint()
    var operationTime: Date! = Date()
    
    override init(frame: CGRect) {
        
        gazePointer = GazePointer(frame: frame)
        let iconSize: CGFloat = 60
        let heightOffset: CGFloat = 20 + 44
        let iconNumX = 4
        let iconNumY = 6
        let marginX: CGFloat = (frame.width-iconSize*CGFloat(iconNumX))/CGFloat(iconNumX+1)
        let marginY: CGFloat = ((frame.height-heightOffset)-iconSize*CGFloat(iconNumY))/CGFloat(iconNumY+1)
        super.init(frame: frame)
//        array.shuffle()
        var iconCount = 1
        for x in 0...iconNumX-1{
            for y in 0...iconNumY-1{
                let iconX = CGFloat(x)*(iconSize + marginX) + marginX
                let iconY = CGFloat(y)*(iconSize + marginY) + heightOffset + marginY
            //位置を変えながらボタンを作る
                let icon : UIButton = iconButton(
                    iconNumber: iconCount,
                    frame:CGRect(x: iconX, y: iconY, width: iconSize, height: iconSize))
            //ボタンを押したときの動作
                icon.addTarget(self, action: #selector(pushed), for: .touchUpInside)
                icon.layer.cornerRadius = 15.0

                icon.backgroundColor = UIColor.systemGray2
                iconCount += 1
                iconArray.append(icon as! IconView.iconButton)
                //画面に追加
                self.addSubview(icon)
            }
        }
        
        self.addSubview(gazePointer)
        
    }
    func resetIcon(){
        for icon in iconArray {
            icon.setTitle("", for: .normal)
            icon.backgroundColor = UIColor.systemGray2
        }
    }
    @objc func iconShuffle(){
        self.array.shuffle()
        resetIcon()
        var printNumber = 1
            for i in 0...9 {
                for icon in iconArray {
                if(array[i] == icon.iconNumber){
                    icon.setTitle(String(printNumber), for: .normal)
                    icon.titleLabel?.font = UIFont(name: "Helvetica-Bold",size: CGFloat(30))
                    printNumber += 1
                    self.rightArray.append(icon.iconNumber)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    //MARK: - ボタン
    @objc func pushed(mybtn : iconButton){
        operationType = "iconButton"
        operationPosition = CGPoint(x: mybtn.center.x+mybtn.frame.width/2, y: mybtn.center.y+mybtn.frame.height/2)
        operationTime = Date()
        if(rightArray.count > 0){
            if(mybtn.iconNumber == self.rightArray[0]){
                rightArray.removeFirst()
                mybtn.backgroundColor = UIColor.systemGreen
                if(rightArray.count == 0){
                    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(iconShuffle), userInfo: nil, repeats: false)
                }
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
        }
    }
    
    func movePointer(to: CGPoint){
        self.gazePointer.center = to
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let view = touch.view else { return }

        if view == self.gazePointer {
            view.center = touch.location(in: self)
        }
    }
}
