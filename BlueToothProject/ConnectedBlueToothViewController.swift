//
//  ConnectedBlueToothViewController.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 9. 1..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import CoreBluetooth
import SocketIO

class ConnectedBlueToothViewController: UIViewController {
    
    var manager : CBCentralManager!
    var peripheral: CBPeripheral!
    var myBluetoothPeripheral : CBPeripheral!
    var myCharacteristic : CBCharacteristic!
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var isMyPeripheralConected = false
    var socket: SocketIOClient!
    
    
    let connectedBlueToothPeripheralDisplayLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let writeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        writeButton.addTarget(self, action: #selector(writeButtonClicked), for: UIControlEvents.touchUpInside)
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.myBluetoothPeripheral = self.peripheral     //save peripheral
        self.myBluetoothPeripheral.delegate = self
        self.socket = SocketManaging.socketManager.socket(forNamespace: "/")
        
        socket.connect()
        
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            print("socket chat connected")
            
            
            
            //self?.socket.emit("requestJoin", myJSON)
            
        }
        //manager.stopScan()                          //stop scanning for peripherals
       // manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
       /* socket.on("receiveMessage") {(data,ack) in
            print("receive")
            self.writeValue(value: "5a")
        }*/
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func writeButtonClicked() {
        print("touch!")
        
        //socket.emit("sendMessage","light")
        //writeValue(value: "5a")
    }
    
    
    
    func UISetUp() {
        self.view.addSubview(connectedBlueToothPeripheralDisplayLabel)
        self.view.addSubview(writeButton)
        
        
        connectedBlueToothPeripheralDisplayLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        connectedBlueToothPeripheralDisplayLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        connectedBlueToothPeripheralDisplayLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.writeButton.topAnchor.constraint(equalTo: self.connectedBlueToothPeripheralDisplayLabel.bottomAnchor, constant: 16).isActive = true
        self.writeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    }
    
    func writeValue(value: String) {
        
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
            // Data("0x5a")
            let dataToSend: Data = value.data(using: String.Encoding.utf8)! //이부분에 해당하는 스트링을 쓰면됨
            let hex = Data(hexString: "5a")!
            
            //let testUInt = UInt8("0x5a", radix: 16)
            //  var hexData = Data(capacity: 2)
            // hexData.append()
            //if dataToSend.isEmpty {print("nil found")}
            print(myCharacteristic)
            //  self.my
            
            self.myBluetoothPeripheral.writeValue(Data(hexString: "5a")!, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)    //실제 write 하는 부분
            print("dataSend")
        } else {
            print("Not connected")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        print("read? :\(RSSI)")
    }
    

}


extension ConnectedBlueToothViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {//CBCentralManagerDelegate 채택시 구현해야하는 메소드
        
        var msg = ""
        
        switch central.state {
        case .poweredOff:
            msg = "Bluetooth is Off"
        case .poweredOn:
            msg = "Bluetooth is On"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Not Supported"
        default:
            msg = "😔"
            
        }
        
        print("STATE: " + msg)
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber?) {
        
        print("Name: \(peripheral.name)") //print the names of all peripherals connected.
        print("searching!!!!!!!")
        print("\(RSSI)")
        
        for alreadyInsideOfarray in peripherals {
            if alreadyInsideOfarray.peripheral.identifier == peripheral.identifier { return }
        }
        
        let rssiValue = RSSI?.floatValue ?? 0.0
        //if peripheral.name != nil {
        peripherals.append((peripheral: peripheral, RSSI: rssiValue))
        peripherals.sort { $0.RSSI < $1.RSSI }
        //tableView.reloadData()
        //  }
        guard let blueToothName = peripheral.name else {return}
        
        if blueToothName == self.myBluetoothPeripheral.name {
       
            self.myBluetoothPeripheral = peripheral     //save peripheral
            self.myBluetoothPeripheral.delegate = self
            
            manager.stopScan()                          //stop scanning for peripherals
            manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
            
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConected = true //블투가 연결되었을 때 실행되는 메서드
        peripheral.delegate = self 
        peripheral.discoverServices(nil)
        print("didConnect")
        
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isMyPeripheralConected = false //블투가 연결 해제 되었을때 실행되는 메서드
    }
    
}

extension ConnectedBlueToothViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripheral = peripheral.services as [CBService]! { //get the services of the perifereal
            print("service is found")
            //블투 찾았을 때
            for service in servicePeripheral {
                
                //Then look for the characteristics of the services
                peripheral.discoverCharacteristics(nil, for: service)
                
            }
            // writeValue(value: "Z1")
            
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("called didUFor")
        if let characterArray = service.characteristics {
            
            for cc in characterArray {
                
                if(cc.uuid.uuidString == "FFE1") { // 내가 공부하기로는 스트링 전송은 FFE1 을 사용해야하는것같음
                    
                    myCharacteristic = cc //saved it to send data in another function.
                    print("char: \(myCharacteristic)")
                    peripheral.setNotifyValue(true, for: cc)
                    peripheral.readValue(for: cc) //to read the value of the characteristic
                }
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("called didU")
        if (characteristic.uuid.uuidString == "FFE1") { // 내가 공부하기로는 스트링 전송은 FFE1 을 사용해야하는것같음
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee //used to read an Int value
            
            if value == 90 {
                print ("touched master device")
                writeValue(value: "some")
            }
            
           // writeValue(value: "5a")
            //sleep()
            if value == 49  {
                print("getting value!!")
                self.socket.emit("sendMessage", "light on")
            }
            print(value)
            
            
        }
    }
    
}

