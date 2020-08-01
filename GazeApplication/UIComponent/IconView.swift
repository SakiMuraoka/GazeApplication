//
//  IconView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    let mapImage: UIImage!
    let galleryImage: UIImage!
    let browserImage: UIImage!
    
    let mapIcon: UIButton!
    let galleryIcon: UIButton!
    let browserIcon: UIButton!
    
    override init(frame: CGRect) {
        
        mapImage = UIImage(named: "mapIcon")
        galleryImage = UIImage(named: "galleryIcon")
        browserImage = UIImage(named: "browserIcon")
        
        mapIcon = UIButton(type: .custom)
        mapIcon.setImage(mapImage, for: .normal)
        galleryIcon = UIButton(type: .custom)
        galleryIcon.setImage(galleryImage, for: .normal)
        browserIcon = UIButton(type: .custom)
        browserIcon.setImage(browserImage, for: .normal)
        
        super.init(frame: frame)
        
        self.addSubview(mapIcon)
        self.addSubview(galleryIcon)
        self.addSubview(browserIcon)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let mapIconOrigin = CGPoint(x: 0, y: 0)
        let mapIconSize = CGSize(width: 80, height: 80)
        mapIcon?.frame = CGRect(origin: mapIconOrigin, size: mapIconSize)
    }
}
