//
//  LoginViewController.swift
//
//  lueToothProject
//  Created by 고상범 on 2018. 10. 4..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit
import SocketIO

class LoginViewController: UIViewController {
    var socket: SocketIOClient!
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.image = nil
        return view
    }()
    
    let loginIdTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "아이디를 입력해주세요"
        textField.textAlignment = .center
        return textField
    }()
    
    let loginPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.textAlignment = .center
        return textField
    }()
    
    let idTextFieldDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    let passwordTextFieldDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    lazy var loginButton: UIButton = {[weak self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Get Started", for: UIControlState.normal)
        button.setTitleColor(#colorLiteral(red: 0.0919258669, green: 0.5034434199, blue: 0.9811272025, alpha: 1), for: UIControlState.normal)
        button.addTarget(self, action: #selector(loginButtonClicked(sender:)), for: UIControlEvents.touchUpInside)
        return button
        }()
    
    lazy var signUpTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        label.text = "아직 회원이 아니신가요?"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    let appTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 54)
        label.text = "Log In"
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var signUpGestureRecognizer: UITapGestureRecognizer = {[weak self] in
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(signUpButtonClicked(sender:)))
        return recognizer
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISetUp()
        
        self.view.backgroundColor = UIColor.white
        self.loginIdTextField.delegate = self
        self.loginPasswordTextField.delegate = self
        self.signUpTextLabel.addGestureRecognizer(signUpGestureRecognizer)
        
    //소켓처리
        socket = SocketManaging.socketManager.socket(forNamespace: "/login")
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }
        socket.connect()
        socket.on("loginSuccess") {[weak self] data, ack in
            print("login gut")
            let tabBarvc: MainTabBarController  = MainTabBarController()
            guard let id = self?.loginIdTextField.text else {return}
            tabBarvc.userId = id
            self?.navigationController?.pushViewController(tabBarvc, animated: true)
        }
    }
    
    @objc func loginButtonClicked(sender: UIButton) {
        print(self.loginIdTextField.text!)
        let myJSON = [
            "userId": "\(self.loginIdTextField.text!)",
            "password": "\(self.loginPasswordTextField.text!)",
            "nickName": "\(self.loginIdTextField.text!)"
        ]
        
        socket.emit("loginRequest", myJSON)
    }
    @objc func loginButtonReleased(sender: UIButton) {
        
    }
    
    @objc func signUpButtonClicked(sender: UIButton) {
        
    }
    
    func UISetUp () {
        self.view.addSubview(logoImageView)
        self.view.addSubview(appTitleLabel)
        self.view.addSubview(idTextFieldDivider)
        self.view.addSubview(loginButton)
        self.view.addSubview(loginIdTextField)
        self.view.addSubview(loginPasswordTextField)
        self.view.addSubview(passwordTextFieldDivider)
        self.view.addSubview(signUpTextLabel)
        
        self.appTitleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        self.appTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        
        self.logoImageView.topAnchor.constraint(equalTo: self.appTitleLabel.bottomAnchor, constant: 84).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.logoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.loginIdTextField.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 54).isActive = true
        self.loginIdTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.loginIdTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.loginIdTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //  self.loginIdTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32).isActive = true
        //self.loginIdTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32).isActive = true
        
        self.idTextFieldDivider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.idTextFieldDivider.widthAnchor.constraint(equalTo: self.loginIdTextField.widthAnchor).isActive = true
        self.idTextFieldDivider.topAnchor.constraint(equalTo: self.loginIdTextField.bottomAnchor, constant: 3).isActive = true
        self.idTextFieldDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        self.loginPasswordTextField.topAnchor.constraint(equalTo: self.idTextFieldDivider.bottomAnchor, constant: 24).isActive = true
        self.loginPasswordTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.loginPasswordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.loginPasswordTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
    
        self.passwordTextFieldDivider.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordTextFieldDivider.topAnchor.constraint(equalTo: self.loginPasswordTextField.bottomAnchor).isActive = true
        self.passwordTextFieldDivider.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
        self.passwordTextFieldDivider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        self.signUpTextLabel.topAnchor.constraint(equalTo: self.passwordTextFieldDivider.bottomAnchor, constant: 16).isActive = true
        self.signUpTextLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64).isActive = true
        
        
        self.loginButton.topAnchor.constraint(equalTo: self.signUpTextLabel.bottomAnchor, constant: 8).isActive = true
        self.loginButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -64).isActive = true
        
        
        
    }
    
}



extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
     @objc func keyboardWillShow(notification: NSNotification) {
     let userInfo = notification.userInfo!
     let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
     let keyboardViewEndFrame = fullScrollView.convert(keyboardEndFrame, from: fullScrollView.window)
     self.fullScrollView.setContentOffset(CGPoint(x: 0, y: keyboardViewEndFrame.height-self.upperView.frame.height), animated: true)
     }
     
     @objc func keyboardWillHide(notification: NSNotification) {
     self.fullScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
     }*/
}
/*
 extension UIButton {
 open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
 UIView.animate(withDuration: 0.5) {
 
 self.transform = CGAffineTransform.identity
 }
 }
 }
 */
