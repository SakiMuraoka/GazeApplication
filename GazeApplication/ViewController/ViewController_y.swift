//
//  ViewController_y.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/18.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//大和さんのアプリケーション

import UIKit
import SceneKit
import ARKit
import WebKit
import ARVideoKit

class ViewController_y: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    //正面カメラからの映像（顔）
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var leftEyeView: UIView!
    @IBOutlet var rightEyeView: UIView!
    @IBOutlet weak var eyePositionIndicatorView: UIView!
    @IBOutlet weak var eyeTrackingPositionView: UIView!
    @IBOutlet weak var eyeTargetPositionXLabel: UILabel!
    @IBOutlet weak var eyeTargetPositionYLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    var eyeTrack = EyeTrack_y(device: Device.iPhone)
    var recorder:RecordAR?

    @IBAction func onClickRecord(_ sender: Any) {
        recorder?.record()
    }
    @IBAction func onClickStop(_ sender: Any) {
        recorder?.stopAndExport()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true

        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        eyeTrack.registerSceneView(sceneView: sceneView)
        recorder = RecordAR(ARSceneKit: sceneView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // スリープ無効
        UIApplication.shared.isIdleTimerDisabled = true
        // Create a session configuration
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("ARFaceTrackingConfiguration Error.")
        }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        recorder?.prepare(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
        recorder?.rest()
    }

    // MARK: - ARSCNViewDelegate


    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user

    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay

    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required

    }
}


extension ViewController_y {
    //新しくアンカーが追加された時（平面が認識された）
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        eyeTrack.faceNode.transform = node.transform
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        updateAnchor(withFaceAnchor: faceAnchor)
    }
    //オブジェクトの更新（オブジェクトが一時停止していない限り，フレームごとに呼び出される）
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let sceneTransformInfo = sceneView.pointOfView?.transform else {
            return
        }
        eyeTrack.virtualDeviceNode.transform = sceneTransformInfo
    }

    //上にあるのと同じ？
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        eyeTrack.faceNode.transform = node.transform
//        guard let faceAnchor = anchor as? ARFaceAnchor else {
//            return
//        }
//        updateAnchor(withFaceAnchor: faceAnchor)
//    }

    func updateAnchor(withFaceAnchor anchor: ARFaceAnchor) {
        //タスクの非同期的追加
        DispatchQueue.main.async {
            self.eyeTrack.update(anchor: anchor)
            self.updateView()
        }
    }

    func getUIImage() {
        let buffer: CVPixelBuffer = self.sceneView.session.currentFrame!.capturedImage
        let ciImage = CIImage(cvPixelBuffer: buffer)
        let temporaryContext = CIContext(options: nil)
        if let temporaryImage = temporaryContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer))) {
            let image = UIImage(cgImage: temporaryImage)
            print(self.getByteArrayFromImage(imageRef: image.cgImage!).count)
        }
    }

    func getByteArrayFromImage(imageRef: CGImage) -> [UInt8] {
        let data = imageRef.dataProvider!.data
        let length = CFDataGetLength(data)
        var rawData = [UInt8](repeating: 0, count: length)
        CFDataGetBytes(data, CFRange(location: 0, length: length), &rawData)
        return rawData
    }

    func updateView() {
        // update indicator position
        self.eyePositionIndicatorView.transform = CGAffineTransform(translationX: eyeTrack.lookAtPosition.x, y: eyeTrack.lookAtPosition.y)

        if eyeTrack.lookAtPoint.x < 0 {
            self.eyeTargetPositionXLabel.text = "0"
        } else {
            self.eyeTargetPositionXLabel.text = "\(Int(round(eyeTrack.lookAtPoint.x)))"
        }

        if eyeTrack.lookAtPoint.y < 0 {
            self.eyeTargetPositionYLabel.text = "0"
        } else {
            self.eyeTargetPositionYLabel.text = "\(Int(round(eyeTrack.lookAtPoint.y)))"
        }

        // Update distance label value
        self.distanceLabel.text = "\(Int(round(eyeTrack.distanceEyeToDevice * 100))) cm"
    }
}


