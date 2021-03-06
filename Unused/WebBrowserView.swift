//
//  WebBrowserView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/26.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserView: UIView, WKUIDelegate, WKNavigationDelegate, UITextFieldDelegate {
    var webView: WKWebView!
    let webConfiguration: WKWebViewConfiguration!
    
    let toolBar: UIToolbar!
    let backButton: UIBarButtonItem!
    let nextButton: UIBarButtonItem!
    
    let urlBar: UIView!
    let urlBarForm: UIView!
    let urlTextField: UITextField!
    let reloadButton: UIButton!
    
    let gazePointer: GazePointer!
    
    override init(frame: CGRect) {
        webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 160, width: frame.width, height: frame.height - 160), configuration: webConfiguration)
        
        let toolbarRegion = CGSize(width: frame.size.width, height: 50)
        let toolbarOrigin = CGPoint(x: 0, y: frame.size.height - 70)
        toolBar = UIToolbar(frame:CGRect(origin: toolbarOrigin, size: toolbarRegion))
        backButton = UIBarButtonItem()
        nextButton = UIBarButtonItem()
        
        urlBar = UIView(frame: CGRect(x: 0, y: 100, width: frame.width, height: 50))
        let urlBarBorderColor : CGColor = CGColor(srgbRed: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        let urlBarBorder : CALayer = CALayer()
        urlBarBorder.frame = CGRect(origin: CGPoint(x: 0, y:50), size: CGSize(width: frame.size.width, height: 0.5))
        urlBarBorder.backgroundColor = urlBarBorderColor
        self.urlBar?.layer.addSublayer(urlBarBorder)
        
        urlBarForm = UIView(frame: CGRect(x: 10, y: 0, width: frame.width - 20 - 30 - 5, height: 40))
        self.urlBarForm?.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        self.urlBarForm?.layer.cornerRadius = 6
        self.urlBarForm?.clipsToBounds = true
        
        urlTextField = UITextField(frame: CGRect(x:8, y: 1, width: self.urlBarForm!.frame.width - 24, height: self.urlBarForm!.frame.height))
        self.urlTextField?.font = UIFont.systemFont(ofSize: 20)
        self.urlTextField?.keyboardType = .URL
        self.urlTextField.clearButtonMode = .whileEditing
        self.urlTextField.keyboardType = .URL
        self.urlTextField.returnKeyType = .google
        
        reloadButton = UIButton(frame: CGRect(x: urlBarForm!.frame.width + 20, y: 10, width: 30, height: 30))
        let reloadImage: UIImage? = UIImage(named: "reload")
        reloadButton.setImage(reloadImage, for: .normal)
        
        gazePointer = GazePointer(frame: frame)
        
        super.init(frame: frame)
        
        webView.uiDelegate = self
        webView?.navigationDelegate = self
        urlTextField.delegate = self
        
        let toolBarItems = [backButton!, nextButton!]
        toolBar.setItems(toolBarItems, animated: true)
        
        backButton.title = "戻る"
        backButton.target = self
        backButton.action = #selector(backButtonAction(_:))
        
        nextButton.title = "進む"
        nextButton.target = self
        nextButton.action = #selector(nextButtonAction(_:))
        
        reloadButton.addTarget(self, action: #selector(reloadButtonAction(_:)), for: .touchUpInside)
        
        self.addSubview(webView)
        self.addSubview(toolBar)
        self.addSubview(urlBar!)
        self.urlBar?.addSubview(urlBarForm!)
        self.urlBarForm?.addSubview(urlTextField!)
        self.urlBar?.addSubview(reloadButton!)
        
        self.addSubview(gazePointer)
        
        webView.topAnchor.constraint(equalToSystemSpacingBelow: self.topAnchor, multiplier: 0.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem){
        print("backButtonAction")
    }
    
    @objc func nextButtonAction(_ sender: UIBarButtonItem){
        print("nextButtonAction")
    }
    
    @objc func reloadButtonAction(_ sender: UIButton){
        sender.imageView?.alpha = 0.01
        loadUrl(url: urlTextField.text!)
        //self.webView?.reload()
    }
    
    func loadUrl(url: String){
        if let url_ = URL(string: url){
            let request = URLRequest(url: url_)
            webView.load(request)
        }else {
            urlTextField.text = "正しいurlを入力してください"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loadUrl(url: urlTextField.text!)
        return true
    }
    
    //  ページの読み込みが完了した時の処理
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        self.urlTextField?.text = self.webView?.url?.absoluteString
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
