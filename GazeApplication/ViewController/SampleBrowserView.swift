//
//  SampleBrowserView.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/07/26.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import UIKit
import ARKit

class SampleBrowserView: UIViewController, ARSessionDelegate {
    var session: ARSession!
    var windowWidth: CGFloat!
    var windowHeight: CGFloat!
    
    var toolBar: UIToolbar!
    var webBrowserView: WebBrowserView!
    
    var mode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = ARSession()
        
        self.title = "ブラウザ"
        
        self.session.delegate = self
        self.windowWidth = self.view.frame.width
        self.windowHeight = self.view.frame.height
        
        webBrowserView = WebBrowserView(frame: self.view.bounds)
        webBrowserView.loadUrl(url: "https://www.google.co.jp/")
        self.view.addSubview(webBrowserView)
        print(mode)
    }
    
    //視線の処理---------
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetTracking()
    }
    
    func resetTracking() {
        let configration = ARFaceTrackingConfiguration()    //front-facingカメラを使ったAR
        self.session.run(configration, options: [.resetTracking, .removeExistingAnchors])   //ARSessionの開始
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frame.anchors.forEach { anchor in
            guard #available(iOS 12.0, *), let faceAnchor = anchor as? ARFaceAnchor else { return }
            
            let faceNode = SCNNode()                        //faceNodeの作成
            faceNode.simdTransform = faceAnchor.transform   //変換行列の設定
            
            let point = faceAnchor.lookAtPoint   //ユーザが見ている点
            
            let cameraTransform = frame.camera.transform    //カメラの位置と向きの情報
        
            //world cordinationにおけるカメラの座標（絶対(0,0,0))
            let cameraPosition = SCNVector3Make(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
            
            
            //face cordinate spaceにおけるカメラの座標（のはず）
            let cameraOnFaceNode = faceNode.convertPosition(cameraPosition, from: nil)
            
            //カメラの向き
            let cameraAngle = SCNVector3Make(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
            let cameraAngleFaceNode = faceNode.convertPosition(cameraAngle, to: nil)
            
            let leftEye = faceAnchor.leftEyeTransform
            let rightEye = faceAnchor.rightEyeTransform
            let eyesCenter = SCNVector3Make(
                            (leftEye.columns.3.x + rightEye.columns.3.x)/2,
                            (leftEye.columns.3.y + rightEye.columns.3.y)/2,
                            (leftEye.columns.3.z + rightEye.columns.3.z)/2)
            
            
            //スクリーン平面の法線ベクトルを計算
            let cameraNorm = SCNVector3Make(cameraAngleFaceNode.x - cameraOnFaceNode.x,
                                            cameraAngleFaceNode.y - cameraOnFaceNode.y,
                                            cameraAngleFaceNode.z - cameraOnFaceNode.z)
            //スクリーンを含む平面と視線ベクトルの交点を求める
            let k = -(cameraNorm.x * (eyesCenter.x - cameraOnFaceNode.x)
                    + cameraNorm.y * (eyesCenter.y - cameraOnFaceNode.y)
                    + cameraNorm.z * (eyesCenter.z - cameraOnFaceNode.z))
                    / (cameraNorm.x * point[0]
                        + cameraNorm.y * point[1]
                        + cameraNorm.z * point[2])
            //スクリーンの中心を始点とするベクトルとして交点を表現
            if k > 0 {
                let intersection = [
                        eyesCenter.x + k * point[0] - cameraOnFaceNode.x,
                        eyesCenter.y + k * point[1] - cameraOnFaceNode.y,
                        eyesCenter.z + k * point[2] - cameraOnFaceNode.z
                    ]
                
                let hardWidth = 70.9
                let hardHeight = 143.6
                var milliIntersection = Array<CGFloat>(repeating: 0, count: 3)
                for i in 0..<3 {
                    milliIntersection[i] = CGFloat(intersection[i] * 1000)
                }
                let widthRate = self.windowWidth / CGFloat(hardWidth)
                let heightRate = self.windowHeight / CGFloat(hardHeight)
                
                milliIntersection[0] = milliIntersection[0] * widthRate
                milliIntersection[1] = milliIntersection[1] * heightRate
                //print("x: \(String(describing: milliIntersection[0])), y: \(String(describing: milliIntersection[1]))")
                //gazePointer.cordinationConvertor(lookAt: milliIntersection)
                let gazex = CGFloat(milliIntersection[0]) + self.windowWidth/2
                let gazey = -CGFloat(milliIntersection[1]) + self.windowHeight/2
                self.webBrowserView.movePointer(to: CGPoint(x: gazex, y: gazey))
            }
        }
    }
    //---------------------------------
}
