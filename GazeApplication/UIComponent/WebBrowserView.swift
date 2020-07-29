//
//  WebBrowserView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/26.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import WebKit

class WebBrowserView: UIView, WKUIDelegate {
    var webView: WKWebView!
    let webConfiguration: WKWebViewConfiguration!
    
    let toolBar: UIToolbar!
    let backButton: UIBarButtonItem!
    let nextButton: UIBarButtonItem!
    
    
    override init(frame: CGRect) {
        webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), configuration: webConfiguration)
        
        let toolbarRegion = CGSize(width: frame.size.width, height: 50)
        let toolbarOrigin = CGPoint(x: 0, y: frame.size.height - 70)
        toolBar = UIToolbar(frame:CGRect(origin: toolbarOrigin, size: toolbarRegion))
        backButton = UIBarButtonItem()
        nextButton = UIBarButtonItem()
        
        super.init(frame: frame)
        
        webView.uiDelegate = self
        
        let toolBarItems = [backButton!, nextButton!]
        toolBar.setItems(toolBarItems, animated: true)
        
        backButton.title = "戻る"
        backButton.target = self
        backButton.action = #selector(backButtonAction(_:))
        
        nextButton.title = "進む"
        nextButton.target = self
        nextButton.action = #selector(nextButtonAction(_:))
        
        self.addSubview(webView)
        self.addSubview(toolBar)
        
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
    
    func loadUrl(url: String){
        guard let url_ = URL(string: url) else { fatalError() }
        let request = URLRequest(url: url_)
        webView.load(request)
    }
}
