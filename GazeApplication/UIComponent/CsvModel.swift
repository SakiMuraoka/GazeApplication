//
//  CsvModel.swift
//  GazeApplication
//
//  Created by 村岡沙紀 on 2020/08/13.
//  Copyright © 2020 村岡沙紀. All rights reserved.
//

import Foundation

class CsvModel {
    //ファイルの場所
    let DOCUMENT_DIRECTORY_PAYH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    
    func write(fileName: String, rowsName: String, dataList: String) {
        let filePath = DOCUMENT_DIRECTORY_PAYH + "/" + fileName
        let fileURL = URL(fileURLWithPath: filePath)
        print("fileName is \(fileName)")
        do {    //ファイルが既に存在する場合
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let contentToWrite = "\n" + dataList
            fileHandle.seekToEndOfFile()
            fileHandle.write(contentToWrite.data(using: .shiftJIS)!)
            print("Success to update an existing file")
        } catch _ as NSError {  //ファイルが存在しない
            do {
                try rowsName.write(to: fileURL, atomically: true, encoding: .shiftJIS)
                let fileHandle = try FileHandle(forWritingTo: fileURL)
                let contentToWrite = "\n" + dataList
                fileHandle.seekToEndOfFile()
                fileHandle.write(contentToWrite.data(using: .shiftJIS)!)
                print("Success to save a new file")
            } catch _ as NSError {
                print("Failed to save a new file")
                assert(false)
            }
        }
    }
    
    func convertConditionsToFileName (name: String, conditions: [String]) -> String {
        var fileName = name
        conditions.forEach {condition in
            var modifiedCondition = condition.replace(from: " ", to: "_")
            modifiedCondition = modifiedCondition.replace(from: ";", to: "")
            modifiedCondition = modifiedCondition.replace(from: "/", to: "-")
            fileName += "_"
            fileName += modifiedCondition
        }
        return fileName
    }
    
    func convertDataToCSV(list: [String]) -> String {
        var csvText: String = ""
        for l in list {
            if csvText != "" {
                csvText += ","
            }
            csvText += l
        }
        return csvText
    }
    
    func convertFigureListToString(dataLists: [[String]]) -> String {
        var csvText = ""
        for dataList in dataLists {
            if csvText != "" {
                csvText += "\n"
            }
            csvText += convertDataToCSV(list: dataList)
        }
        return csvText
    }
    
    func convertDictToStringList(dict: [[String:String]], rows: [String]) -> [[String]] {
        var array: [[String]] = [[]]
        for d in dict {
            var d_tmp: [String] = []
            for r in rows {
                //print("row_name: \(r), value: \(d[r]!)")
                d_tmp.append(d[r]!)
            }
            array.append(d_tmp)
        }
        return array
    }
}


extension String {
    func replace(from: String, to: String) -> String {
        var replacedString = self
        replacedString = replacedString.replacingOccurrences(of: from, with: to)
        return replacedString
    }
}
