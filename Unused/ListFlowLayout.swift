//
//  ListFlowLayout.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class ListFlowLayout: UICollectionViewFlowLayout {

    var itemHeight: CGFloat = 160

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
        minimumInteritemSpacing = 0
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }

    func itemWidth() -> CGFloat {
        return collectionView!.frame.width
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
