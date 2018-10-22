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
    //var peripheral: CBPeripheral!
    var myBluetoothPeripheral : CBPeripheral!
    var myCharacteristic : CBCharacteristic!
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var isMyPeripheralConected = false
    var socket: SocketIOClient!
    
    let indicatingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    let btImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "bluetooth")
        return imageView
    }()
    
    let loadingView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        // view.translatesAutoresizingMaskIntoConstraints = false
        //containerView.safeAddSubView(subView: view, viewTag: 0)
        return containerView
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadingView.aj_showDotLoadingIndicator()
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(listCheckButtonClicked))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        writeButton.addTarget(self, action: #selector(writeButtonClicked), for: UIControlEvents.touchUpInside)
        self.manager = CBCentralManager(delegate: self, queue: nil)
       // self.myBluetoothPeripheral = self.peripheral     //save peripheral
        //self.myBluetoothPeripheral.delegate = self
        self.socket = SocketManaging.socketManager.socket(forNamespace: "/bluetooth")
        self.indicatingTextLabel.text = "블루투스와 페어링 중 입니다."
    
        socket.connect()
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            print("socket BT connected")
        }
        socket.on("receiveMessage") {(data,ack) in
            if UserInformation.userId == "sangbum" {
                
            } else {
                self.writeValue(value: "some")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        
    }

    @objc func writeButtonClicked() {
        print("touch!")
        
        //socket.emit("sendMessage","light")
        //writeValue(value: "5a")
    }
    
    
    
    
    
    private func UISetUp() {
        self.view.addSubview(btImageView)
        self.view.addSubview(loadingView)
        self.view.addSubview(indicatingTextLabel)
        
        self.btImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.btImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.btImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        self.btImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.loadingView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.loadingView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loadingView.topAnchor.constraint(equalTo: self.btImageView.bottomAnchor, constant: 12).isActive = true
        
        self.indicatingTextLabel.topAnchor.constraint(equalTo: self.loadingView.bottomAnchor, constant: 24).isActive = true
        self.indicatingTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.indicatingTextLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    @objc func listCheckButtonClicked() {
        let listVC: BlueToothSearchingTableViewController = BlueToothSearchingTableViewController()
        present(listVC, animated: true, completion: nil)
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
        //print("\(RSSI)")
        
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
        print("name: \(blueToothName)")
        print("name: \(UserInformation.userId)")
        
        if UserInformation.userId == "sangbum" {
            if blueToothName == "TESTING" {
                print("sangbum logged in")
                self.myBluetoothPeripheral = peripheral     //save peripheral
                self.myBluetoothPeripheral.delegate = self
                
                manager.stopScan()                          //stop scanning for peripherals
                manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
                print("sangbum logged in")
                
            }
        } else {
            if blueToothName == "[SABRE]" {
                
                self.myBluetoothPeripheral = peripheral     //save peripheral
                self.myBluetoothPeripheral.delegate = self
                
                manager.stopScan()                          //stop scanning for peripherals
                manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
                
            }
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConected = true //블투가 연결되었을 때 실행되는 메서드
        peripheral.delegate = self 
        peripheral.discoverServices(nil)
        self.indicatingTextLabel.text = "연결되었습니다."
        
        
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
            
            
            
           // writeValue(value: "5a")
            //sleep()
            if UserInformation.userId == "sangbum" {
                if value == 49  {
                    print("sangbum!")
                    print("getting value!!")
                    self.socket.emit("sendMessage", "light on")
                }
            } else {
                if value == 90 {
                    print ("touched master device")
                    writeValue(value: "")
                }
            }
            print(value)
            
            
        }
    }
    
}

