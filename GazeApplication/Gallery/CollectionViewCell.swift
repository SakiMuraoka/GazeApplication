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
    
    var image: UIImage? {
            set {
                
                self.cellImageView?.image = newValue
            }
            get {
                return self.cellImageView?.image
            }
        }
    
        override init(frame: CGRect) {
            self.cellImageView = UIImageView()
            cellImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//            cellImageView.contentMode = UIView.ContentMode.scaleAspectFit
    
            super.init(frame: frame)
    
            contentView.addSubview(cellImageView)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        class func cellOfSize() -> CGSize {
            
            let width = (UIScreen.main.bounds.width - 10) / 4
            return CGSize(width: width, height: width)
        }

//    override init(frame: CGRect) {
//        self.cellImageView = UIImageView()
//        cellImageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
//        cellImageView.contentMode = UIView.ContentMode.scaleAspectFit
//
//        super.init(frame: frame)
//
//        contentView.addSubview(cellImageView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setUpContents(image: UIImage) {
//        cellImageView.image = cropThumbnailImage(image: image, w: 100, h: 100)
//    }
//
//    //画像のリサイズ
//    func cropThumbnailImage(image :UIImage, w:Int, h:Int) ->UIImage
//    {
//        // リサイズ処理
//        let origRef    = image.cgImage
//        let origWidth  = Int(origRef!.width)
//        let origHeight = Int(origRef!.height)
//        var resizeWidth:Int = 0, resizeHeight:Int = 0
//
//        if (origWidth < origHeight) {
//            resizeWidth = w
//            resizeHeight = origHeight * resizeWidth / origWidth
//        } else {
//            resizeHeight = h
//            resizeWidth = origWidth * resizeHeight / origHeight
//        }
//
//        let resizeSize = CGSize.init(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
//
//        UIGraphicsBeginImageContext(resizeSize)
//
//        image.draw(in: CGRect.init(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
//
//        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        // 切り抜き処理
//
//        let cropRect  = CGRect.init(x: CGFloat((resizeWidth - w) / 2), y: CGFloat((resizeHeight - h) / 2), width: CGFloat(w), height: CGFloat(h))
//        let cropRef   = resizeImage!.cgImage!.cropping(to: cropRect)
//        let cropImage = UIImage(cgImage: cropRef!)
//
//        return cropImage
//    }
//
}
