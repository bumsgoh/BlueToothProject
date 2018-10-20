//
//  ChatListTableViewController.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 10. 5..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import SocketIO

class ChatListTableViewController: UITableViewController {
    /*
    let inviteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        return button
    }()*/
    let cellIdentifier: String = "chatCell"
    var userId: String = ""
    var inviteId: String = ""
    var chatRooms: [ChatRoom] = [] {
        didSet {
            OperationQueue.main.addOperation {[weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var socket: SocketIOClient!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ChatListTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        self.socket = SocketManaging.socketManager.socket(forNamespace: "/login/chat")
        socket.connect()
        socket.on(clientEvent: .connect) {[weak self] data, ack in
            print("socket chat connected")
            self?.socket.emit("getChatList", "\(self!.userId)")
        }
        
        self.socket.on("invitedJoin") {(data,ack) in
            for fixed in data {
                var dataDic: [String : Any] = [:]
                print(data)
                dataDic = (fixed as! NSDictionary) as! [String : Any]
                let members: [String] = dataDic["joinMembers"] as! [String]
                let roomId: String = dataDic["roomName"] as! String
                let chatData: ChatRoom = ChatRoom(member: members[0], roomId: roomId)
                self.chatRooms.append(chatData)
            }
            
            OperationQueue.main.addOperation {
            self.tableView.reloadData()
            }
        }
        //self.socket.on("setChatList") {(data,ack) in print(data)}
        self.socket.on("joinSuccess") {(data,ack) in
            let chatVC: ChatViewController = ChatViewController()
            chatVC.userId = self.userId
            self.navigationController?.pushViewController(chatVC, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "invite", style: UIBarButtonItemStyle.plain, target: self, action: #selector(inviteButtonClicked))
    }
   
    @objc func inviteButtonClicked() {
        let alert = UIAlertController(title: "초대하기", message: "초대할 아이디를 입력해주세요", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "아이디를 입력해주세요"
        }
        alert.textFields?[0].clearButtonMode = .always
        alert.addAction(UIAlertAction(title: "invite", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.inviteId = (textField?.text)!
            let myJSON = [
                "id0": "\(self.userId)",
                "id1": "\(self.inviteId)"
            ]
            
            self.socket.emit("requestJoin", myJSON)
            
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ChatListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChatListTableViewCell else {
            return UITableViewCell.init()}
        cell.chatMemberLabel.text = chatRooms[indexPath.row].chatMember
        cell.chatLabel.text = "message comes here" //chatRooms[indexPath.row].roomId
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC: ChatViewController = ChatViewController()
        VC.roomId = chatRooms[indexPath.row].roomId
        VC.socket = self.socket
        self.navigationController?.pushViewController(VC, animated: true)
    }

}
