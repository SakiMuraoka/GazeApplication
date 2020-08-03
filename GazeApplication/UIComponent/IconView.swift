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
    let iconImage1: UIImage!
    let iconImage2: UIImage!
    let iconImage3: UIImage!
    let iconImage4: UIImage!
    let iconImage5: UIImage!
    let iconImage6: UIImage!
    
    let mapIcon: UIButton!
    let galleryIcon: UIButton!
    let browserIcon: UIButton!
    let icon1: UIButton!
    let icon2: UIButton!
    let icon3: UIButton!
    let icon4: UIButton!
    let icon5: UIButton!
    let icon6: UIButton!
    
    let gazePointer: GazePointer!
    
    override init(frame: CGRect) {
        
        mapImage = UIImage(named: "mapIcon")
        galleryImage = UIImage(named: "galleryIcon")
        browserImage = UIImage(named: "browserIcon")
        
        iconImage1 = UIImage(named: "icon1")
        iconImage2 = UIImage(named: "icon2")
        iconImage3 = UIImage(named: "icon3")
        iconImage4 = UIImage(named: "icon4")
        iconImage5 = UIImage(named: "icon5")
        iconImage6 = UIImage(named: "icon6")
        
        mapIcon = UIButton(type: .custom)
        mapIcon.setImage(mapImage, for: .normal)
        mapIcon.accessibilityIdentifier = "map"
        galleryIcon = UIButton(type: .custom)
        galleryIcon.setImage(galleryImage, for: .normal)
        galleryIcon.accessibilityIdentifier = "gallery"
        browserIcon = UIButton(type: .custom)
        browserIcon.setImage(browserImage, for: .normal)
        browserIcon.accessibilityIdentifier = "browser"
        
        icon1 = UIButton(type: .custom)
        icon1.setImage(iconImage1, for: .normal)
        icon2 = UIButton(type: .custom)
        icon2.setImage(iconImage2, for: .normal)
        icon3 = UIButton(type: .custom)
        icon3.setImage(iconImage3, for: .normal)
        icon4 = UIButton(type: .custom)
        icon4.setImage(iconImage4, for: .normal)
        icon5 = UIButton(type: .custom)
        icon5.setImage(iconImage5, for: .normal)
        icon6 = UIButton(type: .custom)
        icon6.setImage(iconImage6, for: .normal)
        
        gazePointer = GazePointer(frame: frame)
        
        super.init(frame: frame)
        
        mapIcon.addTarget(self, action: #selector(self.iconClick(_:)), for: .touchDown)
        galleryIcon.addTarget(self, action: #selector(self.iconClick(_:)), for: .touchDown)
        browserIcon.addTarget(self, action: #selector(self.iconClick(_:)), for: .touchDown)
        
        self.addSubview(mapIcon)
        self.addSubview(galleryIcon)
        self.addSubview(browserIcon)
        
        self.addSubview(icon1)
        self.addSubview(icon2)
        self.addSubview(icon3)
        self.addSubview(icon4)
        self.addSubview(icon5)
        self.addSubview(icon6)
        
        self.addSubview(gazePointer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //ステータスバーとナビゲーションバーの高さ
        let heightOffset: CGFloat = 20 + 44
        let margin: CGFloat = (frame.width-70*3)/4

        let mapIconOrigin = CGPoint(x: margin, y: heightOffset + margin)
        let mapIconSize = CGSize(width: 70, height: 70)
        mapIcon.frame = CGRect(origin: mapIconOrigin, size: mapIconSize)
        
        let galleryIconOrigin = CGPoint(x: 2*margin+70, y: heightOffset + margin)
        let galleryIconSize = CGSize(width: 70, height: 70)
        galleryIcon.frame = CGRect(origin: galleryIconOrigin, size: galleryIconSize)
        
        let browserIconOrigin = CGPoint(x: 3*margin+70*2, y: heightOffset + margin)
        let browserIconSize = CGSize(width: 70, height: 70)
        browserIcon.frame = CGRect(origin: browserIconOrigin, size: browserIconSize)
        
        let icon1Origin = CGPoint(x: margin, y: heightOffset + 2*margin+70)
        let icon1Size = CGSize(width: 70, height: 70)
        icon1.frame = CGRect(origin: icon1Origin, size: icon1Size)
        let icon2Origin = CGPoint(x: 2*margin+70, y: heightOffset + 2*margin+70)
        let icon2Size = CGSize(width: 70, height: 70)
        icon2.frame = CGRect(origin: icon2Origin, size: icon2Size)
        let icon3Origin = CGPoint(x: 3*margin+70*2, y: heightOffset + 2*margin+70)
        let icon3Size = CGSize(width: 70, height: 70)
        icon3.frame = CGRect(origin: icon3Origin, size: icon3Size)
        let icon4Origin = CGPoint(x: margin, y: heightOffset + 3*margin+70*2)
        let icon4Size = CGSize(width: 70, height: 70)
        icon4.frame = CGRect(origin: icon4Origin, size: icon4Size)
        let icon5Origin = CGPoint(x: 2*margin+70, y: heightOffset + 3*margin+70*2)
        let icon5Size = CGSize(width: 70, height: 70)
        icon5.frame = CGRect(origin: icon5Origin, size: icon5Size)
        let icon6Origin = CGPoint(x: 3*margin+70*2, y: heightOffset + 3*margin+70*2)
        let icon6Size = CGSize(width: 70, height: 70)
        icon6.frame = CGRect(origin: icon6Origin, size: icon6Size)
        
    }
    
    @objc func iconClick(_ sender: UIButton){
        switch sender.accessibilityIdentifier{
        case "map":
            print("mapClick")
            break
        case "gallery":
            print("galleryClick")
            break
        case "browser":
            print("browserClick")
            break
        default:
            break
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
