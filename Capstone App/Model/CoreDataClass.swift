//
//  CoreDataClass.swift
//  Capstone App
//
//  Created by Amit Virani on 11/1/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataClass {
    
    let appDelegate:AppDelegate
    let context:NSManagedObjectContext
    let entity:NSEntityDescription?
    let newFile:NSManagedObject
    
    init() {
         appDelegate = UIApplication.shared.delegate as! AppDelegate
         context = appDelegate.persistentContainer.viewContext
         entity = NSEntityDescription.entity(forEntityName: "FileData", in: context)
         newFile = NSManagedObject(entity: entity!, insertInto: context)
    }
    
    func addNewFileName(fileName:String, date:String) {
        newFile.setValue(fileName, forKey: "fileName")
        newFile.setValue(date, forKey: "fileDate")
        
        //saving data
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getAllFileNames() -> [String] {
        
        var arrayOfFileNames:[String] = []
        var arrayOfFileDates:[String] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FileData")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                let fileName = data.value(forKey: "fileName") as! String
                 let fileDate = data.value(forKey: "fileDate") as! String
                
                arrayOfFileNames.append(fileName)
                
                print(data.value(forKey: "fileName") as! String)
                print(data.value(forKey: "fileDate") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
        
        return arrayOfFileNames
    }
    
}
