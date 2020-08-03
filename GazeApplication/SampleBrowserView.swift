//
//  SampleBrowserView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/26.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit

class SampleBrowserView: UIViewController {
    var toolBar: UIToolbar!
    var webBrowserView: WebBrowserView!
    
    var mode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ブラウザ"
        webBrowserView = WebBrowserView(frame: self.view.bounds)
        webBrowserView.loadUrl(url: "https://www.google.co.jp/")
        self.view.addSubview(webBrowserView)
        print(mode)
    }
}
