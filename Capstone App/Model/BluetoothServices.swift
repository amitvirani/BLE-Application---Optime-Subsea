//
//  BluetoothServices.swift
//  BleTutorial
//
//  Created by Amit Virani on 10/8/18.
//  Copyright © 2018 Amit Virani. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothServices : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //variable declarations
    var characteristicUUID1:CBUUID
    //var characteristicUUID2:CBUUID
    //    var servicesUUID:CBUUID
    //    var peripheralUUID:CBUUID
    var discoveredPeripheral:CBPeripheral?
    var centralManager: CBCentralManager!
    var writingCharacteristic:CBCharacteristic?
    var readingCharacteristic:CBCharacteristic?
    var isConnected: Bool = false
    var dataReceived:String?
    var dataRead : Bool = false
     let file1 = FileManagerClass(file: "File1")
    var dataCollected:String = ""
    var testVariable = 1
    
    
    //static let sharedBleInstance = BluetoothServices(charac1UUID: <#T##CBUUID#>)
    
    //class init
    init(charac1UUID:CBUUID) {
        characteristicUUID1 = charac1UUID
        //        characteristicUUID2 = charac2UUID
        //        servicesUUID = serviceUUID
        //        peripheralUUID = deviceUUID
        super.init()
        
        let bleQueue = DispatchQueue(label: "BleQueue", qos: .default, attributes: .concurrent)
        bleQueue.async {
            self.centralManager = CBCentralManager(delegate: self, queue: bleQueue)
        }
        
        
    }
    
    
    
    //protocol defined method
    //checks whether iphone's bluetooth services are in which state.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Central.state is .unknown")
        case .resetting:
            print("Central.state is .ressetting")
        case .unsupported:
            print("Central.state is .unsupported")
        case .unauthorized:
            print("Central.state is .unauthorized")
        case .poweredOff:
            print("Central.state is .powered off")
        case .poweredOn:
            print("Central.state is .powered on")
            
            //after checking device's bluetooth status
            //next task is to scan for peripherals, we are using scanForPeripherals func to discover peripherals
            //we can scan for specific peripherals by providing specific characteristicUUIDS in func parameter
            centralManager.scanForPeripherals(withServices: [characteristicUUID1])
            print("Executed: scanForPeripherals")
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("Executed: didDiscover")
        //we found peripheral with characteristics we are interested in
        print(peripheral)
        //saving reference of discovered peripheral
        discoveredPeripheral = peripheral
        
        //setting peripheral delegate to self
        discoveredPeripheral?.delegate = self
        
        //telling the central manager to stop scanning as we already found peripheral
        centralManager.stopScan()
        
        //connecting with discovered peripheral
        //this code calls didConnect func of centralManager delegate
        centralManager.connect(discoveredPeripheral!)
    }
    
    //this function check whether connection is established between device and newly discovered peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Iphone is connected to: \(peripheral.name!) Successfully!")
        
        isConnected = true
        //to discover services related to discovered peripheral
        //this will call didDiscoverServices func of CBPeripheral Protocol
        discoveredPeripheral!.discoverServices(nil)
        
        print("Executed: didConnect")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
          
            //this will call -- didDiscoverCharacteristicsFor func of CBperipheral
            peripheral.discoverCharacteristics([], for: service)
            // print(service.characteristics!)
        }
        
        print("Executed: didDiscoverServices")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Executed: didDiscoverCharacteristicsFor")
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            
            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")
            }
            if characteristic.properties.contains(.notify) {
                print("\(characteristic.uuid): properties contains .notify")
               readingCharacteristic = characteristic
            writingCharacteristic = characteristic
                //to turn on reading/notify for data
                 peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                writingCharacteristic = characteristic
                print("\(characteristic.uuid): properties contains .write")
            }
        }
    }
    
    // function to write to peripheral
    func writeToPeripheral( _ dataToWrite: UInt8) {
        let data = Data(bytes: [dataToWrite])
        self.discoveredPeripheral?.writeValue(data, for: writingCharacteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    //function to check connection status of peripheral
    func checkConnectionStatus() -> Bool {
        
        if (isConnected == true) {
            print("Iphone is connected to peripheral")
        }else {
            print("Iphone is not connected to peripheral")
        }
        return isConnected
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //we received data in Data type lets decode it to string
        
        let bleQueue2 = DispatchQueue(label: "BleQueue2", qos: .default, attributes: .concurrent)
        bleQueue2.async {
            self.decodeReceivedData(peripheralCharacteristic: characteristic)
        }
        // decodeReceivedData(peripheralCharacteristic: characteristic)
        dataRead = true
    }
    
    func decodeReceivedData(peripheralCharacteristic:CBCharacteristic) -> () {
        
        guard let characteristicData = peripheralCharacteristic.value else { return }
        let byteArray = [UInt8](characteristicData)
        
        dataReceived = String(bytes: byteArray, encoding: String.Encoding.ascii)!
        print(dataReceived)

        
//        writeToPeripheral(123)
//        let seperatedString = dataReceived!.components(separatedBy: "_")
//        print(seperatedString[0] + seperatedString[1])
//
//        dataCollected.append("Temperature:\(seperatedString[0]);Pressure:\(seperatedString[1])\n")
//         ******* Juck Code **************
//         convertToString(byteArray: byteArray)
//          print("Received Data1:", String(decoding: characteristicData, as: UTF8.self))
//          var dataArray:[String] = []
//          dataArray.append(sensorData!)
//         print("Received Data2:",String(bytes: byteArray, encoding: String.Encoding.ascii)!)
        
    }
    
    func readReceivedFromPeripheral() -> String {
        if (dataRead == true) {
            return dataReceived!}
        else {
            return "No data received from peripheral"
        }
    }
    
    func startReadingData(){
        discoveredPeripheral!.setNotifyValue(true, for: readingCharacteristic!)

    }
    
    func stopReadingData(){
        discoveredPeripheral!.setNotifyValue(false, for: readingCharacteristic!)
        file1.wrtiteToFile(data:dataCollected)
    }
    
    
    func gpsControl(switch:Bool){
        
    }
    
    func bmpControl(switch:Bool){
        
    }
    
    func setSamplingRate(samplingRate:Int){
        
    }
    func setTempWarinng(temperature:Double){
        
    }
    
}

