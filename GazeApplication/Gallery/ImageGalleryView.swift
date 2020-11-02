//
//  ImageGalleryView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/25.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class ImageGalleryView: UIView{
    
    var collectionView: UICollectionView!
    
    var collectionViewData = CollectionViewData()
    
    let gazePointer: GazePointer!
    
    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    
    var selectedImageView : UIImageView?
    
    var navigation: UINavigationController?
    
    
    override init(frame: CGRect) {
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 100, width: frame.size.width, height: frame.size.height - 100), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        gazePointer = GazePointer(frame: frame)
        
        selectedImageView = UIImageView()
        
              
        super.init(frame: frame)
        
        self.windowWidth = self.frame.width
        self.windowHeight = self.frame.height
        //Viewを追加
        self.addSubview(collectionView)
        
//        self.addSubview(gazePointer)
      
//        collectionView.delegate = self
//        collectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-レイアウト
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func createImageView() -> UIImageView? {
        
        guard let selectedImageView = self.selectedImageView else {
            return nil
        }
        let imageView = UIImageView(image: selectedImageView.image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = selectedImageView.convert(selectedImageView.frame, to: self)
        return imageView
    }
    
    //MARK:-セルの処理
    //表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewData.data[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.collectionViewData.sectionName.count
    }
    // 表示するセルを登録
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",for: indexPath as IndexPath) as! CollectionViewCell
        let cellImage = UIImage(named: collectionViewData.photo[indexPath.section][indexPath.item])!
//        cell.setUpContents(image: cellImage)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let collectionViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! CollectionViewHeader
        let headerText = collectionViewData.sectionName[indexPath.section][indexPath.item]
        collectionViewHeader.setUpContents(titleText: headerText)
        return collectionViewHeader
    }
     //セルの大きさや隙間の調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 5
        let cellSize : CGFloat = self.windowWidth / 3 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    //セルが選択された時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath as IndexPath) as! CollectionViewCell
        self.selectedImageView = cell.cellImageView

        let storyboard = UIStoryboard(name: "detailView", bundle: nil)
        let nextView = storyboard.instantiateViewController(withIdentifier: "detailView") as! DetailViewController
        nextView.image = self.selectedImageView!.image
        print(indexPath)
//        navigationController?.pushViewController(nextView, animated: true)
    }
    
    // ヘッダーのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.size.width, height:50)
    }

    //MARK:-視線ポインタ
//    func movePointer(to: CGPoint){
//        self.gazePointer.center = to
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let view = touch.view else { return }
//
//        if view == self.gazePointer {
//            view.center = touch.location(in: self)
//        }
//    }
}
