//
//  Resolver.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/10/28.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation
import Resolver
import EyeTrackKit
import UIKit

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { EyeTrackController(device: EyeTrackKit.Device(screenSize: CGSize(width: 0.0757, height: 0.1509), screenPointSize: CGSize(width: 828 / 2, height: 1792 / 2), compensation: CGPoint(x: 0, y: 0)), smoothingRange: 10, blinkThreshold: .infinity, isHidden: false) }.scope(application)
        register { DataController() }.scope(application)
    }
}
