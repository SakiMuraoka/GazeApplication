//
//  PopupView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/09/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class PopupView: UIView{
    let popup: UIView!
    let textLabel: UILabel!
    let yesButton: UIButton!
    let noButton: UIButton!
        
    override init(frame: CGRect) {
        self.popup = UIView(frame: CGRect(x:0, y:100, width: 350, height: 300))
        self.textLabel = UILabel()
        self.yesButton = UIButton(type: .system)
        self.noButton = UIButton(type: .system)
        
        super.init(frame: frame)

        self.isOpaque = false
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.popup.backgroundColor = UIColor.white
        
        self.textLabel.text = "xxxxx"
        
        yesButton.setTitle("はい", for: .normal)
        noButton.setTitle("いいえ", for: .normal)
        
        
        self.addSubview(popup)
        self.popup.addSubview(textLabel)
        self.popup.addSubview(yesButton)
        self.popup.addSubview(noButton)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        popup.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        textLabel.center = CGPoint(x: popup.frame.width/2, y: 40)
        textLabel.sizeToFit()
        
        yesButton.center = CGPoint(x:3*popup.frame.width/4, y:popup.frame.height - 40)
        yesButton.sizeToFit()
        
        noButton.center = CGPoint(x:popup.frame.width/4, y:popup.frame.height - 40)
        noButton.sizeToFit()
    }
    
    func textLabelChange(text: String){
        self.textLabel.text = text
    }

}
