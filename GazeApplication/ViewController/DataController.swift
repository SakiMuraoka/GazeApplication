//
//  DataController.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/10/27.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation
import CSV
import EyeTrackKit
import UIKit

enum DataStatus {
    case INITIALIZED
    case RECORDING
    case FINISHED
}

public class DataController: ObservableObject {
    @Published var status: DataStatus = .INITIALIZED
    @Published var datas: [[Any]] = []
    //ファイルの場所
    let DOCUMENT_DIRECTORY_PAYH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!

    public func start() {
        self.status = .RECORDING
        print("datacontroller start")
    }

    public func add(info: EyeTrackInfo, targetPoint: CGPoint) {
        if self.status == .RECORDING {
            self.datas.append([info, targetPoint])
        }
    }
    public func add(info: EyeTrackInfo, operationType: String, operationPoint: CGPoint){
        if self.status == .RECORDING {
            self.datas.append([info, operationType, operationPoint])
        }
    }

    public func stop() {
        print("Acquired \(datas.count) frames")
        self.status = .FINISHED
    }

    public func export(name: String, coloumns: [String], rows: [[String]]) -> Void {
        let stream = OutputStream(toFileAtPath: name, append: false)!
        let csv = try! CSVWriter(stream: stream)
        try! csv.write(row: coloumns)
        for row in rows {
            try! csv.write(row: row)
        }
        csv.stream.close()
    }
    
    public let gaze_COLUMNS = ["targetPoint-x", "targetPoint-y"]
    public let other_COLUMNS = ["operationType", "operationPoint-x", "operationPoint-y"]

    public func export(name: String, myapp: String) -> Void {
        let filePath = DOCUMENT_DIRECTORY_PAYH + "/" + name  + ".csv"
        let fileURL = URL(fileURLWithPath: filePath)
        let stream = OutputStream(url: fileURL, append: false)!
        let csv = try! CSVWriter(stream: stream)
        if(myapp == "eyegaze" || myapp == "eye"){
            try! csv.write(row: EyeTrackInfo.CSV_COLUMNS + gaze_COLUMNS)
            for data in datas {
                let info = data[0] as! EyeTrackInfo
                let targetPoint = data[1] as! CGPoint
                let targetPoint_ = [targetPoint.x, targetPoint.y]
                var plusData_:[String] = []
                for i in 0..<targetPoint_.count {
                    plusData_.append(String(format: "%.8f", targetPoint_[i] as CVarArg))
                }
                let row = info.toCSV + plusData_
                try! csv.write(row: row)
            }
        }else{
            try! csv.write(row: EyeTrackInfo.CSV_COLUMNS + other_COLUMNS)
            for data in datas {
                let info = data[0] as! EyeTrackInfo
                let operationType = data[1] as! String
                let oPoint = data[2] as! CGPoint
                let oPoint_ = [oPoint.x, oPoint.y]
                var plusData_:[String] = [operationType]
                for i in 0..<oPoint_.count {
                    plusData_.append(String(format: "%.8f", oPoint_[i] as CVarArg))
                }
                let row = info.toCSV + plusData_
                try! csv.write(row: row)
            }
        }
        csv.stream.close()
        
    }

    public func reset() {
        self.datas.removeAll()
        self.status = .INITIALIZED
    }
}

