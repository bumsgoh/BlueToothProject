//
//  ChatViewController.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 9. 18..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController {
    
    var userId: String = ""
    let reuseIdentifier: String = "chatBubbleCell"
    var roomId: String = ""
    var message: [[String: String]] = [] {
        didSet {
            OperationQueue.main.addOperation {[weak self] in
                self?.chatCollectionView.reloadData()
            }
        }
    }
    var width: CGFloat?
    var socket: SocketIOClient!
    var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var isKeyboardShowOnce: Bool = false
    
    let chatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()
    
    let chatInputBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let chatTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = true
        view.backgroundColor = UIColor.white
       
        
        
        return view
    }()
    
    let chatSendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("send", for: UIControlState.normal)
        //button.backgroundColor = UIColor.lightGray
        //button.setTitleColor(UIColor., for: UIControlState.normal)
        button.setImage(#imageLiteral(resourceName: "bluetooth-logo-with-background"), for: UIControlState.normal)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTextView.text = "Type your message"
        chatTextView.textColor = UIColor.lightGray
        chatTextView.delegate = self
        chatCollectionView.register(ChatBubbleCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.view.backgroundColor = UIColor.white
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        if #available(iOS 11.0, *) {
            chatCollectionView.contentInsetAdjustmentBehavior = .always
        }
        if UIDevice.current.orientation.isPortrait == true {
            width = UIScreen.main.bounds.width
        } else {
            width = UIScreen.main.bounds.height
        }
       // self.socket = manager.defaultSocket
        self.socket = SocketManaging.socketManager.socket(forNamespace: "/login/chat")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        UISetUp()
        self.chatSendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        /*
            self?.socket.on("invitedJoin") {(data,ack) in
                print("joined")
                print(data)
                let myJSON = [
                    "message": "test message1",
                    "userId": "1",
                    "roomName": "141a7a6d-2cc6-4601-a9e2-d5ccca816bf0"
                ]
                //message.append(myJSON)
                
                
                self?.socket.emit("sendMessage", myJSON)
                
            }*/
        //socket.connect()
        let myJSON = [
            "roomName": "\(roomId)"
        
        ]
        socket.emit("storedMessage", myJSON)
        
        socket.on("responseStoredMessage") {(data,ack) in
            
            let dataArray: NSArray = data as! NSArray
            let rData: NSArray = dataArray[0] as! NSArray
            for msgData in rData {
                let msg: [String: String] = (msgData as! NSDictionary) as! [String : String]
                print("message is \(msg["message"])")
                self.message.append(["message": msg["message"]!, "sendMessageId": msg["sendMessageId"]!])
            }
            OperationQueue.main.addOperation {
                self.chatCollectionView.reloadData()
            }
            
        }
        
        socket.on("receiveMessage") {(data,ack) in
            
            let dataArray: NSArray = data as! NSArray
            //let rData: NSArray = dataArray[0] as! NSArray
            for msgData in dataArray {
                let msg: [String: String] = (msgData as! NSDictionary) as! [String : String]
                print("message is \(msg["message"])")
                self.message.append(["message": msg["message"]!, "sendMessageId": msg["userId"]!])
            }
            print(data)
            OperationQueue.main.addOperation {
                self.chatCollectionView.reloadData()
            }
            
        }
        
        
        }
    
    func UISetUp() {
        self.view.addSubview(chatCollectionView)
        self.view.addSubview(chatInputBackgroundView)
        self.chatInputBackgroundView.addSubview(chatTextView)
        self.chatInputBackgroundView.addSubview(chatSendButton)
        self.chatCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.chatCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.chatCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.chatCollectionView.bottomAnchor.constraint(equalTo: self.chatInputBackgroundView.topAnchor).isActive = true
        
       
        
        self.chatInputBackgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.chatInputBackgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.chatInputBackgroundView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let bottomConstraint = NSLayoutConstraint(item: chatInputBackgroundView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 16.0)
        self.bottomConstraint = bottomConstraint
        bottomConstraint.isActive = true //키보드가 올라왔을때 뷰를 조정하기 위해서 따로 설정하였습니다.
        
        self.chatTextView.topAnchor.constraint(equalTo: self.chatInputBackgroundView.topAnchor).isActive = true
        self.chatTextView.leadingAnchor.constraint(equalTo: self.chatInputBackgroundView.leadingAnchor, constant: 16).isActive = true
        self.chatTextView.widthAnchor.constraint(equalTo: self.chatInputBackgroundView.widthAnchor, multiplier: 0.7).isActive = true
        self.chatTextView.bottomAnchor.constraint(equalTo: self.chatInputBackgroundView.bottomAnchor).isActive = true
        
        //self.chatSendButton.topAnchor.constraint(equalTo: self.chatInputBackgroundView.topAnchor).isActive = true
        self.chatSendButton.centerYAnchor.constraint(equalTo: self.chatInputBackgroundView.centerYAnchor).isActive = true
        self.chatSendButton.trailingAnchor.constraint(equalTo: self.chatInputBackgroundView.trailingAnchor, constant: -8).isActive = true
        //self.chatSendButton.trailingAnchor.constraint(equalTo: self.chatInputBackgroundView.trailingAnchor, constant: -16).isActive = true
        self.chatSendButton.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        self.chatSendButton.widthAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        
        
        
    }
    
    @objc func sendButtonClicked() {
        
        let myJSON = [
            "message": "\(chatTextView.text!)",
            "userId": "\(userId)",
            "roomName": "\(roomId)"
        ]
        //message.append(myJSON)
        
        
        socket.emit("sendMessage", myJSON)
        OperationQueue.main.addOperation {
            self.chatTextView.text = ""
            self.chatCollectionView.reloadData()
        }
        
        
    }
    
    
    func adjustingHeight(_ show:Bool, notification:NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey]) as? CGRect else {return}
        guard let animationDurarion: TimeInterval = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {return}
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDurarion, animations: {() in
            self.bottomConstraint.constant -= changeInHeight
        })
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if !isKeyboardShowOnce{
            adjustingHeight(true, notification: notification)
        }
        isKeyboardShowOnce = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        adjustingHeight(false, notification: notification)
        isKeyboardShowOnce = false
    }
}
extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //guard let width = self.width else {return CGSize.init()}
        if let messageText: [String: String] = self.message[indexPath.row] {
            let size: CGSize = CGSize(width: 250, height: 1000)
            let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedForm = NSString(string: messageText["message"]!).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: self.view.frame.width, height: estimatedForm.height + 20)
        }
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
extension ChatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(message.count)
        return message.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ChatBubbleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatBubbleCollectionViewCell
        
        let messageText: [String: String] = self.message[indexPath.row]
            let size: CGSize = CGSize(width: 250, height: 1000)
            let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedForm = NSString(string: messageText["message"]!).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        
        if !(messageText["sendMessageId"] == "\(userId)") {
            cell.chatTextView.frame = CGRect(x: 40 + 8, y: 0, width: estimatedForm.width + 16, height: estimatedForm.height + 20)
            
             cell.textBubbleView.frame = CGRect(x: 40, y: 0, width: estimatedForm.width + 24, height: estimatedForm.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
            cell.chatTextView.textColor = UIColor.black
            cell.thumbNailImageView.image = #imageLiteral(resourceName: "hairstyle")
        } else {
            cell.chatTextView.frame = CGRect(x: self.view.frame.width - estimatedForm.width - 16, y: 0, width: estimatedForm.width + 16, height: estimatedForm.height + 20)
            
            cell.textBubbleView.frame = CGRect(x: self.view.frame.width - estimatedForm.width - 24, y: 0, width: estimatedForm.width + 24, height: estimatedForm.height + 20)
            cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/245, blue: 249/255, alpha: 1)
            cell.chatTextView.textColor = UIColor.white
        }
        //cell.backgroundColor = UIColor.white
        //cell.thumbNailImageView.image =
        //cell.titleLabel.text = countryName[indexPath.row]
        //cell.layer.addShadow()
       // cell.layer.roundCorners(radius: 10)
        cell.chatTextView.text = message[indexPath.row]["message"]!
        return cell
    }
   
}


extension ChatViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Type your message"
            textView.textColor = UIColor.lightGray
        }
    }
}








