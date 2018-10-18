//
//  ViewController.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 8. 17..
//  Copyright © 2018년 고상범. All rights reserved.
//


import UIKit
import CoreBluetooth
import SocketIO

let cellIdentifier: String = "peripheralCell"
class BlueToothSearchingTableViewController: UITableViewController {
    
    var manager : CBCentralManager!
    var myBluetoothPeripheral : CBPeripheral!
    var myCharacteristic : CBCharacteristic!
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    var isMyPeripheralConected = false
    //var socket: SocketIOClient!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BlueToothPeripheralTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.manager = CBCentralManager(delegate: self, queue: nil)
        //self.manager = CBCentralManager(delegate: self, queue: nil)
        
       
    }
    
    //블투로 스트링 보내는 메서드
    func writeValue(value: String) {
        
        if isMyPeripheralConected { //check if myPeripheral is connected to send data
           // Data("0x5a")
            let dataToSend: Data = value.data(using: String.Encoding.utf8)! //이부분에 해당하는 스트링을 쓰면됨
          
            print(myCharacteristic)
            self.myBluetoothPeripheral.writeValue(dataToSend, for: myCharacteristic, type: CBCharacteristicWriteType.withoutResponse)    //실제 write 하는 부분
            print("dataSend")
        } else {
            print("Not connected")
        }
    }
    
   
    
    
    @IBAction func onAndOff(_ sender: UISegmentedControl) {
        
        
        if sender.selectedSegmentIndex == 0 {
            writeValue(value: "on")
            print("on")
        } else {
            writeValue(value: "off")
        }
        
    }
}
extension BlueToothSearchingTableViewController: CBCentralManagerDelegate {
    
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
        if peripheral.name != nil {
        peripherals.append((peripheral: peripheral, RSSI: rssiValue))
        peripherals.sort { $0.RSSI < $1.RSSI }
        tableView.reloadData()
        }
        guard let blueToothName = peripheral.name else {return}
        
        if blueToothName == "HMSOFT1" { //이 부분에 너가 미리 정해놓은 블루투스 이름을 쓰삼 아두이노 명령어는 AT+NAME원하는이름 ex> AT+NAMEBUM
            
            print("conneted")
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

extension BlueToothSearchingTableViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let servicePeripheral = peripheral.services as [CBService]! { //get the services of the perifereal
            print("service is found")
            //블투 찾았을 때
            for service in servicePeripheral {
                
                //Then look for the characteristics of the services
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let characterArray = service.characteristics {
            
            for cc in characterArray {
                
                if(cc.uuid.uuidString == "FFE1") { // 내가 공부하기로는 스트링 전송은 FFE1 을 사용해야하는것같음
                    
                    myCharacteristic = cc //saved it to send data in another function.
                    print("char: \(myCharacteristic)")
                    peripheral.readValue(for: cc) //to read the value of the characteristic
                }
                
            }
        }
        
    }
   
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (characteristic.uuid.uuidString == "FFE1") { // 내가 공부하기로는 스트링 전송은 FFE1 을 사용해야하는것같음
            
            let readValue = characteristic.value
            
            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee //used to read an Int value
            
            print (value)
            
        }
    }
    
}


extension BlueToothSearchingTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: BlueToothPeripheralTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BlueToothPeripheralTableViewCell else {
            return UITableViewCell.init()
        }
        if peripherals[indexPath.row].peripheral.name != nil {
            guard let name = peripherals[indexPath.row].peripheral.name else {return UITableViewCell.init()}
           // guard let rssi = peripherals[indexPath.row].RSSI else {return UITableViewCell.init()}
            
            cell.blueToothPeripheralNameLabel.text = "name: \(name)"
            cell.blueToothRSSILabel.text = "strength: \(peripherals[indexPath.row].RSSI)"
        } else {
            cell.blueToothPeripheralNameLabel.text = "no name"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
        self.myBluetoothPeripheral = peripherals[indexPath.row].peripheral//save peripheral
        print("trying to connect to \(self.myBluetoothPeripheral)")
        self.myBluetoothPeripheral.delegate = self
        manager.stopScan()                          //stop scanning for peripherals
        //manager.connect(myBluetoothPeripheral, options: nil) //connect to my peripheral
        guard let name = self.myBluetoothPeripheral.name else {return}
        let VC: ConnectedBlueToothViewController = ConnectedBlueToothViewController()
        VC.connectedBlueToothPeripheralDisplayLabel.text = "Now connected with \(name) and Central is interacting with it"
        VC.peripheral = myBluetoothPeripheral
        self.present(VC, animated: true, completion: nil)
        
        //print("conneted")

        
    }
    
    
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        for i in 0..<len {
            let j = hexString.index(hexString.startIndex, offsetBy: i*2)
            let k = hexString.index(j, offsetBy: 2)
            let bytes = hexString[j..<k]
            if var num = UInt8(bytes, radix: 16) {
                data.append(&num, count: 1)
            } else {
                return nil
            }
        }
        self = data
    }
}
