//
//  HomeView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class HomeView: UIViewController {
    var iconView: IconView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconView = IconView(frame: self.view.bounds)
        self.view.addSubview(iconView)
        
        self.title = "ホーム"
    }
}
