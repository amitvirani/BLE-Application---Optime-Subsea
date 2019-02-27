//
//  DeviceStatusViewController.swift
//  Capstone App
//
//  Created by Amit Virani on 10/31/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import UIKit
import CoreBluetooth

let deviceServicesId = CBUUID(string: "0xFFE0")

class DeviceStatusViewController:UIViewController {
    
    //UI Variables
    
    @IBOutlet weak var bluetoothLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var gpsLabel: UILabel!
    @IBOutlet weak var writingToSDLabel: UILabel!
    
    var bleServices:BluetoothServices?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     bleServices = BluetoothServices(charac1UUID: deviceServicesId)
        
        let tabBarCon = tabBarController as! TabBarViewController
            tabBarCon.bleObject = bleServices
        
        //get device status & send responce to update ui method
        //call update UI Function to update the labels
        
       
        
    }
    
    
    
    func establishConnection(){
        if (bleServices!.isConnected == true) {
            print("Connection Established")
        }else {
            print("No Connection")
        }
    
    }
    
    func configureDeviceStatus() {
        
    }
    
    //test function
    func getFileName() ->String {
        
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let fileName = "Data_D\(day)M\(month)H\(hour)M\(minutes)S\(seconds)"
        print(fileName)
        return fileName
    }
    
    func getDate() -> String{
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        return "\(month)\(day)"
        
    }
    func UpdateUI() {
        // call writeToDevice function with parameter 99 to get the status of device
        let respnceString = "101010"
        if bleServices?.isConnected == true {
            bluetoothLabel.text = "Connected"
        }else {
            bluetoothLabel.text = "Disconnected"
        }
        //
        if( respnceString.contains("11")){
           temperatureLabel.text = "On"
        } else {
            temperatureLabel.text = "Off"
        }
        
        if( respnceString.contains("21")){
            temperatureLabel.text = "Writing To Sd Card"
        } else {
            temperatureLabel.text = "Idle"
        }
        
        if( respnceString.contains("31")){
            temperatureLabel.text = "Active"
        } else {
            temperatureLabel.text = "Disabled"
        }
       
    }
}
