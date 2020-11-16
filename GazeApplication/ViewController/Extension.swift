//
//  Extension.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/16.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation
import UIKit
import EyeTrackKit

extension EyeTrackViewController {
    func timeToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSSSS"
        return formatter.string(from: date)
    }
}
