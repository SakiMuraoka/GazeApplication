//
//  File.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class GridFlowLayout: UICollectionViewFlowLayout {
    
    let itemHeight: CGFloat = 160
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width:itemWidth(), height:itemHeight)
        }
        get {
            return CGSize(width:itemWidth(), height:itemHeight)
        }
    }

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

    func itemWidth() -> CGFloat {
        return (collectionView!.frame.width/2)-1
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
