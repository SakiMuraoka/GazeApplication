//
//  EyeTrackInfo_.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/11/04.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation
import ARKit
import EyeTrackKit

public class EyeTrackInfo_ {
    
    public var myapp: String  = ""

    public static let gaze_COLUMNS = ["targetPoint-x", "targetPoint-y"]
    public static let other_COLUMNS = ["operationType", "operationPoint-x", "operationPoint-y"]
    public var COLUMNS: [String] = []
    
    public var targetPoint:CGPoint!
    public var operationType:String!
    public var operationPoint:CGPoint!

    public init(targetPoint: CGPoint) {
        self.targetPoint = targetPoint
    }
    
    public init(operationType: String, operationPoint: CGPoint){
        self.operationType = operationType
        self.operationPoint = operationPoint
    }

    public var toCSV:[String] {
    var row: [String]
    if(myapp == "eyegaze"){
        self.COLUMNS = EyeTrackInfo_.gaze_COLUMNS
        row = [self.targetPoint.x.description, self.targetPoint.y.description]
    }else{
        self.COLUMNS = EyeTrackInfo_.other_COLUMNS
        row = [operationType, self.operationPoint.x.description, self.operationPoint.y.description]
        }
    return row
    }
}
