//
//  FilesViewController.swift
//  Capstone App
//
//  Created by Amit Virani on 10/31/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet weak var File_picker: UIPickerView!
    @IBOutlet weak var fileData_textView: UITextView!
    
     var bleServices:BluetoothServices?
    
    var fileNames:[String] = [ ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bleServices = BluetoothServices(charac1UUID: deviceServicesId)
        let tabBarCon = tabBarController as! TabBarViewController
        tabBarCon.bleObject = bleServices
        
        let coreDataClassObject = CoreDataClass()
        fileNames = coreDataClassObject.getAllFileNames()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        return fileNames.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fileNames[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(fileNames[row])
        
        retriveDataOfSelectedFile(nameOfFile: fileNames[row])
    }
    
    func retriveDataOfSelectedFile(nameOfFile:String) {
        // code for retriving perticular file data
        // update the textview with the data in file
        
        let fileObject = FileManagerClass(file: nameOfFile)
        let dataInTextFile = fileObject.readFromFile()
        fileData_textView.text = dataInTextFile
    }
}
