//
//  DemoMenuView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/02.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class DemoMenuView: UIViewController, UITableViewDelegate,UITableViewDataSource {

    //スクリーンの横幅、縦幅を定義
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    let tableRowHeight = 100
    //テーブルビューインスタンス作成
    var sampleTableView: UITableView  =   UITableView()

    //テーブルに表示するセル配列
    var exampleArray: [String] = ["視線", "ホーム"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // タイトルを付けておきましょう
        self.title = "デモ"
        
        //テーブルビューの設置場所を指定
        sampleTableView.frame = CGRect(x:screenWidth * 0/100, y:screenHeight * 10/100, width:screenWidth * 100/100, height:tableRowHeight * exampleArray.count)
        sampleTableView.delegate = self
        sampleTableView.dataSource = self
        sampleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(sampleTableView)
        self.sampleTableView.rowHeight = CGFloat(tableRowHeight)
    }
    
    func numberOfSections(in sampleTableView: UITableView) -> Int {
           return 1
       }

       //表示するcellの数を指定
       func tableView(_ sampleTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return exampleArray.count
       }

       //cellのコンテンツ
       func tableView(_ sampleTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
           //cellにはsampleArrayが一つずつ入るようにするよ！
           cell.textLabel?.text = exampleArray[indexPath.row]
           return cell
       }

       //cellが選択された時の処理
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("\(indexPath.row)番セルが押されたよ！")
        switch indexPath.row {
        case 0:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "eyePointView_y") as! EyePointView_y
            nextView.mode = "demo"
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        case 1:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "homeView") as! HomeView
            nextView.mode = "demo"
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        default:
            break
        }
       }
}

