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
    let text = "xxxxx"
        
    override init(frame: CGRect) {
        self.popup = UIView(frame: CGRect(x:0, y:100, width: 350, height: 300))
        self.textLabel = UILabel()
    
        super.init(frame: frame)

        self.isOpaque = false
        self.backgroundColor = UIColor(white: 0, alpha: 0.2)
        self.popup.backgroundColor = UIColor.white
        self.textLabel.text = text
        self.addSubview(popup)
        self.popup.addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        popup.center = CGPoint(x: frame.width/2, y: frame.height/2)
        
        textLabel.center = CGPoint(x: popup.frame.width/2, y: 20)
        textLabel.sizeToFit()
        
    }
}
