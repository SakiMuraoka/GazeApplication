//
//  Node.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/19.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//大和さん

import Foundation
import UIKit
import SceneKit
import ARKit

enum DeviceType {
    case iPhone
    case iPad
}

// デバイス情報保持クラス
class Device {
    let type: DeviceType
    let screenSize: CGSize
    let screenPointSize: CGSize

    var node: SCNNode
    var screenNode: SCNNode

    init(type: DeviceType) {
        self.type = type
        switch type {
        case DeviceType.iPhone:
            self.screenSize = CGSize(width: 0.0714, height: 0.1440)
            self.screenPointSize = CGSize(width: 1125 / 3, height: 2436 / 3)
        case DeviceType.iPad:
            self.screenSize = CGSize(width: 0.1785, height: 0.2476)
            self.screenPointSize = CGSize(width: 1668 / 3, height: 2388 / 3)
        }

        // Node生成
        self.node = SCNNode()
        self.screenNode = {
            let screenGeometry = SCNPlane(width: 1, height: 1)
            screenGeometry.firstMaterial?.isDoubleSided = true
            screenGeometry.firstMaterial?.diffuse.contents = UIColor.green
            let vsNode = SCNNode()
            vsNode.geometry = screenGeometry
            return vsNode
        }()
        self.node.addChildNode(self.screenNode)

    }
}

// 顔情報保持クラス
class Face {
    let node: SCNNode
    let rightEye: Eye
    let leftEye: Eye
    var transform: simd_float4x4 = simd_float4x4()


    init() {
        // Node生成
        self.node = SCNNode()
        self.rightEye = Eye()
        self.leftEye = Eye()
        self.node.addChildNode(self.leftEye.node)
        self.node.addChildNode(self.rightEye.node)
    }

    func update(anchor: ARFaceAnchor) {
        // 座標更新
        self.transform = anchor.transform
        self.leftEye.node.simdTransform = anchor.leftEyeTransform
        self.rightEye.node.simdTransform = anchor.rightEyeTransform
        // 瞬き情報更新
        self.leftEye.blink = anchor.blendShapes[.eyeBlinkLeft]?.floatValue ?? 0.0
        self.rightEye.blink = anchor.blendShapes[.eyeBlinkRight]?.floatValue ?? 0.0
    }

    // デバイスとの距離を取得
    func getDistanceToDevice() -> Float {
        // Average distance from two eyes
        (self.leftEye.getDistanceToDevice() + self.rightEye.getDistanceToDevice()) / 2
    }


}

// 目情報保持クラス
class Eye {
    var lookAtPosition: CGPoint = CGPoint(x: 0, y: 0)
    var blink: Float = 1.0
    var node: SCNNode
    var target: SCNNode


    init() {
        // Node生成
        self.node = {
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
        self.target = SCNNode()
        self.node.addChildNode(self.target)
        self.target.position.z = 2
    }

    // Deviceとの距離を取得
    func getDistanceToDevice() -> Float {
        (self.node.worldPosition - SCNVector3Zero).length()
    }

    // [目と視点を結ぶ直線]と[デバイスのスクリーン平面]の交点を取得
    func hittingAt(device: Device) -> CGPoint {
        let heightCompensation: CGFloat = 312

        let deviceScreenEyeHitTestResults = device.node.hitTestWithSegment(from: self.target.worldPosition, to: self.node.worldPosition, options: nil)
        for result in deviceScreenEyeHitTestResults {
            self.lookAtPosition.x = CGFloat(result.localCoordinates.x) / (device.screenSize.width / 2) * device.screenPointSize.width
            self.lookAtPosition.y = CGFloat(result.localCoordinates.y) / (device.screenSize.height / 2) * device.screenPointSize.height + heightCompensation
        }

        return self.lookAtPosition
    }
}
