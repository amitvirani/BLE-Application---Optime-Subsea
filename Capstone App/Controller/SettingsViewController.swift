//
//  SettingsViewController.swift
//  Capstone App
//
//  Created by Amit Virani on 10/31/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
     var bleServices:BluetoothServices?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarCon = tabBarController as! TabBarViewController
        let bleManagerObject:BluetoothServices = tabBarCon.bleObject!
        
        bleManagerObject.writeToPeripheral(1)
        
    }
    


}
