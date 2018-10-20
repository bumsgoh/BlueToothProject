//
//  ChatRoom.swift
//  AbroadApp
//
//  Created by 고상범 on 2018. 9. 18..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

struct ChatRoom {
    let chatMember: String
    let roomId: String
    
    init(member: String, roomId: String) {
        self.chatMember = member
        self.roomId = roomId
    }
}
