//
//  RetriveDataViewController.swift
//  Capstone App
//
//  Created by Amit Virani on 10/31/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import UIKit

class RetriveDataViewController: UIViewController {

    @IBOutlet weak var retrivedData_textView: UITextView!
    
     var bleServices:BluetoothServices?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bleServices = BluetoothServices(charac1UUID: deviceServicesId)
        let tabBarCon = tabBarController as! TabBarViewController
        tabBarCon.bleObject = bleServices
        // Do any additional setup after loading the view.
    }
    
    
    //code to retrive data from Sd Card
    @IBAction func retriveFromSD_button(_ sender: Any) {
        
        
        //do not forget to update the text of  text view
    }
    
    //code to save data to new File
    @IBAction func saveDataToFile_btn(_ sender: Any) {
        let newFileName = getFileName()
        let fileObject = FileManagerClass(file: newFileName[0])
        let coreDataObject = CoreDataClass()
        fileObject.wrtiteToFile(data: retrivedData_textView.text!)
        coreDataObject.addNewFileName(fileName: newFileName[0], date: newFileName[1])
    
    }
    //code to discard data in the text view
    @IBAction func discardData_btn(_ sender: Any) {
        retrivedData_textView.text = "....No Data Available to display. Please retrive data from sd card to see new data."
    }
    
    //funct for generating file name
    func getFileName() -> [String] {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
     //   let seconds = calendar.component(.second, from: date)
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let fileName = "Data_D:\(day)M:\(month)H:\(hour)M:\(minutes)"
        print(fileName)
        
        //file name convention goes here...
        
        let dateOfFile = "\(day):\(month)"
        return [fileName,dateOfFile]
    }
  

}
