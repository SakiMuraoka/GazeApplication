//
//  ImageGalleryView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class SampleGalleryView: UIViewController {
    var imageGalleryView: ImageGalleryView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "画像ギャラリ"
        imageGalleryView = ImageGalleryView(frame: self.view.bounds)
        self.view.addSubview(imageGalleryView)
    }
}
