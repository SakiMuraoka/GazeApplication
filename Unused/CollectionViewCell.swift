//
//  CollectionViewCell.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

// CollectionViewのセル設定
class CollectionViewCell: UICollectionViewCell {
    let cellImageView: UIImageView!
    
    override init(frame: CGRect) {
        self.cellImageView = UIImageView()
        cellImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        cellImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        super.init(frame: frame)
        
        contentView.addSubview(cellImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContents(image: UIImage) {
        cellImageView.image = image
    }
}
