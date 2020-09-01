//
//  TestMenuView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/02.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class TestMenuView: UIViewController, UITableViewDelegate,UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    //スクリーンの横幅、縦幅を定義
    let screenWidth = Int(UIScreen.main.bounds.size.width)
    let screenHeight = Int(UIScreen.main.bounds.size.height)
    let tableRowHeight = 100
    let margin = 10
    
    var pickerViewField: UITextField!
    var pickerView: UIPickerView = UIPickerView()
    var userNames =  ["ユーザ名", "saki", ]
    var addUserButton: UIButton!
    var addUserField: UITextField!

    //テーブルビューインスタンス作成
    var sampleTableView: UITableView  =   UITableView()

    //テーブルに表示するセル配列
    var exampleArray: [String] = ["視線", "ホーム", "マップ", "ギャラリ", "ブラウザ"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // タイトルを付けておきましょう
        self.title = "テスト"
        
        addUserButton = UIButton(type: UIButton.ButtonType.contactAdd)
        addUserButton.center = CGPoint(x:screenWidth * 10/100, y: screenHeight * 13/100 + margin)
        addUserButton.addTarget(self, action: #selector(addUserButtonClick(_:)), for: UIControl.Event.touchUpInside)
        addUserField = UITextField(frame: CGRect(x:0, y: 0, width: screenWidth * 60/100, height: 50))
        addUserField.center = CGPoint(x:screenWidth * 50/100, y: screenHeight * 13/100 + margin)
        addUserField.borderStyle = .bezel
        addUserField.delegate = self
        addUserField.isHidden = true
        addUserField.placeholder = "ユーザ名を入力してください"
        
        pickerViewField = UITextField(frame: CGRect(x:0, y: 0, width: screenWidth * 60/100, height: 50))
        pickerViewField.center = CGPoint(x:screenWidth * 50/100, y: screenHeight * 13/100 + margin)
        pickerViewField.borderStyle = .bezel
        pickerViewField.inputView = pickerView
        pickerViewField.tintColor = UIColor.clear
        pickerViewField.delegate = self
        pickerViewField.text = userNames[0]

        
        self.pickerView.frame = CGRect(x: 0, y: screenHeight * 10/100, width: screenWidth, height: Int(pickerView.bounds.size.height))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //テーブルビューの設置場所を指定
        sampleTableView.frame = CGRect(x:0, y:screenHeight * 13/100 + Int(pickerViewField.bounds.size.height) + margin, width:screenWidth, height:tableRowHeight * exampleArray.count)
        sampleTableView.delegate = self
        sampleTableView.dataSource = self
        sampleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.sampleTableView.rowHeight = CGFloat(tableRowHeight)
        
        self.view.addSubview(addUserButton)
        self.view.addSubview(addUserField)
        self.view.addSubview(pickerViewField)
        self.view.addSubview(sampleTableView)
    }
    
    @objc func addUserButtonClick(_ sender: UIButton){
        addUserField.isHidden = false
        pickerViewField.isHidden = true
        addUserField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addUserField.isHidden = true
        addUserField.resignFirstResponder()
        pickerViewField.isHidden = false
        userNames.append(addUserField.text!)
        pickerViewField.text = addUserField.text!
        addUserField.text = ""
        return true
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
            nextView.mode = "test"
            nextView.username = pickerViewField.text!
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        case 1:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "homeView") as! HomeView
            nextView.mode = "test"
            nextView.username = pickerViewField.text!
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        case 2:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "mapView") as! SampleMapView
            nextView.mode = "test"
            nextView.username = pickerViewField.text!
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        case 3:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "galleryView") as!
            SampleGalleryView
            nextView.mode = "test"
            nextView.username = pickerViewField.text!
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        case 4:
            let nextView = self.storyboard!.instantiateViewController(withIdentifier: "browserView") as! SampleBrowserView
            nextView.mode = "test"
            nextView.username = pickerViewField.text!
            self.navigationController?.pushViewController(nextView, animated: true)
            break
        default:
            break
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userNames[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userNames.count
    }

    // 各選択肢が選ばれた時の操作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(userNames[row])
        pickerViewField.text = userNames[row]
//        switch row {
//        case 0:
//            break
//        case 1:
//            break
//        case 2:
//            break
//        case 3:
//            break
//        default:
//            break
//        }
    }
}


