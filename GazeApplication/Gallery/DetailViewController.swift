//
//  DetailViewController.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/01.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var image: UIImage?
    var imageView: UIImageView!
    var toolBar: UIToolbar!
    @objc var filterButton: UIButton!
            
        override func viewDidLoad() {
            super.viewDidLoad()
            imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.center = self.view.center
            
            toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.bounds.height-100, width: self.view.bounds.width, height: 100))
            
            filterButton = UIButton(frame: CGRect(x: 0, y:0, width: 100, height: 40))
            filterButton.setTitle("Filter", for: .normal)
            filterButton.addTarget(self, action: #selector(filterButton(_:)), for: .touchUpInside)
            let filterButtonItem = UIBarButtonItem(customView: filterButton)
            
            toolBar.items = [filterButtonItem]
            
            self.view.backgroundColor = UIColor.white
            self.view.addSubview(imageView)
            self.view.addSubview(toolBar)
        }
    
    @objc func filterButton(_ sender: UIButton) {
        print("フィルターボタンがクリックされた")
    }
        
        func createImageView() -> UIImageView? {

            guard let detailImageView = self.imageView else {
                return nil
            }
            let imageView = UIImageView(image: self.image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = detailImageView.frame
            return imageView
        }
        
}
