//
//  MainView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/09/05.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//
import UIKit

class MainView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

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

    var popupView: PopupView!
    
    var modeLabel: UILabel!
    var modeSegment: UISegmentedControl!
    var modeParams = ["デモ", "テスト"]
    var mymode = 0
    
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
        
        pickerView.frame = CGRect(x: 0, y: screenHeight * 10/100, width: screenWidth, height: Int(pickerView.bounds.size.height))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        popupView = PopupView(frame: self.view.bounds)
        popupView.textLabelChange(text: "ユーザ名を選択してください")
        popupView.yesButton.isHidden = true
        popupView.noButton.isHidden = true
        popupView.isHidden = true
        
        modeLabel = UILabel(frame: CGRect(x: 10, y: pickerViewField.center.y + 50, width: 100, height: 50))
        modeLabel.text = "モード"
        modeLabel.sizeToFit()
        modeSegment = UISegmentedControl(items: modeParams)
        modeSegment.center = CGPoint(x: self.view.center.x, y: modeLabel.center.y)
        modeSegment.selectedSegmentIndex = 0
        
        self.view.addSubview(addUserButton)
        self.view.addSubview(addUserField)
        self.view.addSubview(pickerViewField)
        self.view.addSubview(popupView)
        self.view.addSubview(modeLabel)
        self.view.addSubview(modeSegment)
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

       //cellが選択された時の処理
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("\(indexPath.row)番セルが押されたよ！")
        if(pickerViewField.text == userNames[0]){
            popupView.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.popupView.isHidden = true
            }
        }else{
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


