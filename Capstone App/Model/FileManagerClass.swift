//
//  FileManagerClass.swift
//  BleTutorial
//
//  Created by Amit Virani on 10/17/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import Foundation

class FileManagerClass {
    var fileName:String
    var fileURL:URL
    
    
    init(file:String) {
        fileName = file
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
    }
    
    func wrtiteToFile(data:String) {
        do {
            try data.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Failed To write:", error)
        }
    }
    
    func readFromFile() -> String {
        var contentsOfFile:String = ""
        do {
            contentsOfFile = try String(contentsOf: fileURL)
        }
        catch let error as NSError {
            print("Failed To Read:", error)
        }
        return contentsOfFile
    }
    
    func getFileName() ->String {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let fileName = "Data_D:\(day)M:\(month)H:\(hour)M:\(minutes)"
        print(fileName)
        return fileName
    }
    
}
