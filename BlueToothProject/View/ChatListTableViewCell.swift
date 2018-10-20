//
//  ChatListTableViewCell.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 10. 5..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "hairstyle")
        return view
    }()
    
    let chatMemberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "BBQ Fried Chicken is amazing!"
        return label
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        UISetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func UISetUp() {
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(chatMemberLabel)
        self.contentView.addSubview(chatLabel)
        
        self.profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        
        
        self.chatMemberLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4).isActive = true
        self.chatMemberLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16).isActive = true
        
        self.chatLabel.topAnchor.constraint(equalTo: self.chatMemberLabel.bottomAnchor, constant: 8).isActive = true
        self.chatLabel.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 16).isActive = true
        
        
        
        
        
    }
    

}
