//
//  EyeTrack_y.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/18.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import ARKit

enum Device {
    case iPhone
    case iPad
}

class EyeTrack_y {
    let IS_BLINK_THRESHOLD: Float = 0.4
    let SMOOTHING_RANGE: Int = 10

    let screenSize: CGSize
    let screenPointSize: CGSize
    let device: Device

    var lookAtPositionXs: [CGFloat] = []
    var lookAtPositionYs: [CGFloat] = []
    var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    var lookAtPoint: CGPoint = CGPoint(x: 0, y: 0)

    var faceTransform: simd_float4x4 = simd_float4x4()

    var leftEyeLookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    var rightEyeLookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    var distanceEyeToDevice: Float = 0.0
    var leftEyeBlinkValue: Float = 1.0
    var rightEyeBlinkValue: Float = 1.0

    init(device: Device) {
        self.device = device
        switch device {
        case Device.iPhone:
            self.screenSize = CGSize(width: 0.0714, height: 0.1440)
            self.screenPointSize = CGSize(width: 1125 / 3, height: 2436 / 3)
        case Device.iPad:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = CGSize(width: 1668 / 3, height: 2388 / 3)
        }
    }

    var faceNode: SCNNode = SCNNode()
    var leftEyeNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)
        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.red

        let eyeNode = SCNNode()
        eyeNode.geometry = geometry
        eyeNode.eulerAngles.x = -.pi / 2

        eyeNode.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(eyeNode)
        return parentNode
    }()

    var rightEyeNode: SCNNode = {
        let geometry = SCNCone(topRadius: 0.005, bottomRadius: 0, height: 0.1)

        geometry.radialSegmentCount = 3
        geometry.firstMaterial?.diffuse.contents = UIColor.red

        let eyeNode = SCNNode()
        eyeNode.geometry = geometry
        eyeNode.eulerAngles.x = -.pi / 2

        eyeNode.position.z = 0.1
        let parentNode = SCNNode()
        parentNode.addChildNode(eyeNode)
        return parentNode
    }()

    var targetLeftEyeNode: SCNNode = SCNNode()
    var targetRightEyeNode: SCNNode = SCNNode()

    var virtualDeviceNode: SCNNode = SCNNode()

    var virtualScreenNode: SCNNode = {
        let screenGeometry = SCNPlane(width: 1, height: 1)
        screenGeometry.firstMaterial?.isDoubleSided = true
        screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
        let vsNode = SCNNode()
        vsNode.geometry = screenGeometry
        return vsNode
    }()

    // SceneViewと紐つける
    func registerSceneView(sceneView: ARSCNView) {
        sceneView.scene.rootNode.addChildNode(faceNode)
        sceneView.scene.rootNode.addChildNode(virtualDeviceNode)
        virtualDeviceNode.addChildNode(virtualScreenNode)
        faceNode.addChildNode(leftEyeNode)
        faceNode.addChildNode(rightEyeNode)
        leftEyeNode.addChildNode(targetLeftEyeNode)
        rightEyeNode.addChildNode(targetRightEyeNode)

        targetLeftEyeNode.position.z = 2
        targetRightEyeNode.position.z = 2
    }

    // ARFaceAnchorを基に情報を更新
    func update(anchor: ARFaceAnchor) {
        faceTransform = anchor.transform
        leftEyeNode.simdTransform = anchor.leftEyeTransform
        rightEyeNode.simdTransform = anchor.rightEyeTransform
        // 目と見ている場所を結ぶ直線と画面の交点を取得
        var leftEyeHittingAt = CGPoint()
        var rightEyeHittingAt = CGPoint()

        let heightCompensation: CGFloat = 312
        let deviceScreenEyeRHitTestResults = self.virtualDeviceNode.hitTestWithSegment(from: self.targetLeftEyeNode.worldPosition, to: self.leftEyeNode.worldPosition, options: nil)
        let deviceScreenEyeLHitTestResults = self.virtualDeviceNode.hitTestWithSegment(from: self.targetRightEyeNode.worldPosition, to: self.rightEyeNode.worldPosition, options: nil)

        for result in deviceScreenEyeLHitTestResults {
            leftEyeHittingAt.x = CGFloat(result.localCoordinates.x) / (self.screenSize.width / 2) * self.screenPointSize.width
            leftEyeHittingAt.y = CGFloat(result.localCoordinates.y) / (self.screenSize.height / 2) * self.screenPointSize.height + heightCompensation
        }

        for result in deviceScreenEyeRHitTestResults {
            rightEyeHittingAt.x = CGFloat(result.localCoordinates.x) / (self.screenSize.width / 2) * self.screenPointSize.width
            rightEyeHittingAt.y = CGFloat(result.localCoordinates.y) / (self.screenSize.height / 2) * self.screenPointSize.height + heightCompensation
        }


        // Calculate distance of the eyes to the camera
        let distanceL = self.leftEyeNode.worldPosition - SCNVector3Zero
        let distanceR = self.rightEyeNode.worldPosition - SCNVector3Zero

        // Average distance from two eyes
        self.distanceEyeToDevice = (distanceL.length() + distanceR.length()) / 2
        // 目の開き度を取得
        self.leftEyeBlinkValue = anchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
        self.rightEyeBlinkValue = anchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0

        // 瞬き判定
        if self.leftEyeBlinkValue > self.IS_BLINK_THRESHOLD {
            print("Close")
        } else {
            self.lookAtPositionXs.append((rightEyeHittingAt.x + leftEyeHittingAt.x) / 2)
            self.lookAtPositionYs.append(-(rightEyeHittingAt.y + leftEyeHittingAt.y) / 2)
            self.lookAtPositionXs = Array(self.lookAtPositionXs.suffix(self.SMOOTHING_RANGE))
            self.lookAtPositionYs = Array(self.lookAtPositionYs.suffix(self.SMOOTHING_RANGE))
            self.lookAtPosition = CGPoint(x: self.lookAtPositionXs.eyePositionAverage!, y: self.lookAtPositionYs.eyePositionAverage!)
            self.lookAtPoint = CGPoint(x: self.lookAtPosition.x + self.screenPointSize.width / 2, y: self.lookAtPosition.y + self.screenPointSize.height / 2)
        }
    }

}
