//
//  ChatBubbleCollectionViewCell.swift
//  AbroadApp
//
//  Created by 고상범 on 2018. 9. 19..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class ChatBubbleCollectionViewCell: UICollectionViewCell {
    
    
    let thumbNailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let chatTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        UISetUp()
    }
    override func prepareForReuse() {
        chatTextView.text = ""
        thumbNailImageView.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func UISetUp() {
        self.contentView.addSubview(textBubbleView)
        self.contentView.addSubview(thumbNailImageView)
        self.textBubbleView.addSubview(chatTextView)
        
       // textBubbleView.leadingAnchor.constraint(equalTo: self.thumbNailImageView.trailingAnchor).isActive = true
       // textBubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -46).isActive = true
        textBubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        textBubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        //chatTextView.leadingAnchor.constraint(equalTo: self.textBubbleView.leadingAnchor).isActive = true
       // chatTextView.trailingAnchor.constraint(equalTo: self.textBubbleView.trailingAnchor).isActive = true
        chatTextView.topAnchor.constraint(equalTo: self.textBubbleView.topAnchor).isActive = true
        chatTextView.bottomAnchor.constraint(equalTo: self.textBubbleView.bottomAnchor).isActive = true
       // chatTextView.leadingAnchor.constraint(equalTo: self.textBubbleView.leadingAnchor, constant: 16).isActive = true
        //imageView Setting
        //thumbNailImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        thumbNailImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        thumbNailImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 30).isActive = true
        thumbNailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        //thumbNailImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        thumbNailImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 8).isActive = true
        
        //thumbNailImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        //thumbNailImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4).isActive = true
        //thumbNailImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -4).isActive = true
        
        //titleLabel Setting
        
        //titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 4).isActive = true
        
        
        // self.contentView.layer.masksToBounds = true
        
    }
}
