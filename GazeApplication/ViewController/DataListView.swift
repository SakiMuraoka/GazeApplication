//
//  AnimationView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/17.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class DataListView: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    var filePath:String!
    var fileNames: [String] = []
    
    //最初からあるメソッド
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentPath = NSHomeDirectory() + "/Documents"
        guard let fileNames = try? FileManager.default.contentsOfDirectory(atPath: documentPath) else {
            print("ファイル名を読み込めませんでした")
            return
        }
        self.fileNames = fileNames
            
        self.tableView = {
            let tableView = UITableView(frame: self.view.bounds, style: .plain)
            tableView.autoresizingMask = [
              .flexibleWidth,
              .flexibleHeight
            ]
            tableView.delegate = self
            tableView.dataSource = self

            self.view.addSubview(tableView)

            return tableView
        }()
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.fileNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
      ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")

      cell.textLabel?.text = self.fileNames[indexPath.row]

      return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected! \(self.fileNames[indexPath.row])")
        let fileName = fileNames[indexPath.row]
        let nextView = self.storyboard!.instantiateViewController(withIdentifier: "animation") as! AnimationView
        nextView.fileName = fileName
        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    //データを返すメソッド
    private func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        
        //セルを取得する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath as IndexPath) as UITableViewCell
        
        let fileName = fileNames[indexPath.row]
        
        do {
            //ユーザーが保存したCSVファイルのパス
            filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + fileName + ".csv"
            
            print(fileName)
 
        } catch {
        }
        
        //セルのラベルに部名、部室を設定する。
 
        return cell
    }
}

