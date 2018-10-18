//
//
//  Created by 고상범 on 2018. 10. 4..
//  Copyright © 2018년 고상범. All rights reserved.
//

//
//  SocketManager.swift
//  AbroadApp
//
//  Created by 고상범 on 2018. 10. 4..
//  Copyright © 2018년 고상범. All rights reserved.
//

import Foundation
import SocketIO

class SocketManaging {
    static var socketManager = SocketManager(socketURL: URL(string: "http://ec2-18-223-185-177.us-east-2.compute.amazonaws.com:80/")!, config: [.log(false), .compress])
    private init() {}
    
}
