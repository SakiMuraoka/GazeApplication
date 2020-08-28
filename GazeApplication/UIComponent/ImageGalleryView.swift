//
//  ImageGalleryView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class ImageGalleryView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let segmentedControl: UISegmentedControl!
    var segmentedControlTitle: [String]!
    var segmentedState = 1
    
    var collectionView: UICollectionView!
    
    var collectionViewData = CollectionViewData()
    
    let gazePointer: GazePointer!
    
    override init(frame: CGRect) {
        //UISegmentedControlの作成と初期化
        segmentedControlTitle = ["リスト", "グリッド"]
        self.segmentedControl = UISegmentedControl(items: segmentedControlTitle)
        segmentedControl.selectedSegmentIndex = 0
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: frame.size.width, height: frame.size.height - 150), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        gazePointer = GazePointer(frame: frame)
              
        super.init(frame: frame)
        //Viewを追加
        self.addSubview(segmentedControl)
        self.addSubview(collectionView)
        
        self.addSubview(gazePointer)
        
        //segmentedControlのイベント初期化
        segmentedControl.addTarget(self, action: #selector(segmentedControlChenged(_:)), for: UIControl.Event.valueChanged)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let frameSize = frame.size
        
        //segmentedControlのレイアウト
        let segmentedControlRegion = CGSize(width: frameSize.width - 20, height: 40)
        let segmentedCOntrolOrigin = CGPoint(x: 10, y: 100)
        self.segmentedControl.frame = CGRect(origin: segmentedCOntrolOrigin, size: segmentedControlRegion)
    }
    
    @objc func segmentedControlChenged(_ sender: UISegmentedControl) {
        segmentedState = sender.selectedSegmentIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.data[section].count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collectionViewData.sectionName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath as IndexPath) as! CollectionViewCell
        let cellImage = UIImage(named: collectionViewData.photo[indexPath.section][indexPath.item])!
        cell.setUpContents(image: cellImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionViewHeader
        let headerText = collectionViewData.sectionName[indexPath.section][indexPath.item]
        collectionViewHeader.setUpContents(titleText: headerText)
        return collectionViewHeader
    }
     //セルの大きさ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 160
        var width: CGFloat = 0
        switch segmentedState {
        case 0:
            width = self.frame.size.width
        case 1:
            //4列に
            width = (self.frame.width) / 5
        default:
            break
        }
        return CGSize(width: width, height:  height)
    }
    
     //セルの余白
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // ヘッダーのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.size.width, height:50)
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
