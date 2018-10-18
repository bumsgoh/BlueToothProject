//
//  BlueToothPeripheralTableViewCell.swift
//  BlueToothProject
//
//  Created by 고상범 on 2018. 9. 1..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class BlueToothPeripheralTableViewCell: UITableViewCell {

    let blueToothPeripheralNameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let blueToothRSSILabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    override func prepareForReuse() {
        self.blueToothPeripheralNameLabel.text = ""
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        UISetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("error")
    }
}

extension BlueToothPeripheralTableViewCell {
    
    func UISetUp() {
        self.contentView.addSubview(blueToothPeripheralNameLabel)
        self.contentView.addSubview(blueToothRSSILabel)
        
        self.blueToothPeripheralNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
       // self.blueToothPeripheralNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.blueToothPeripheralNameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        self.blueToothRSSILabel.leadingAnchor.constraint(equalTo: self.blueToothPeripheralNameLabel.trailingAnchor, constant: 16).isActive = true
        self.blueToothRSSILabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        
        
        
    }
}
