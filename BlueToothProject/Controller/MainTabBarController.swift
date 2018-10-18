//
//  MainTabBarController.swift
//
//
//  Created by 고상범 on 2018. 10. 6..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViewControllers()
    }
    func makeViewControllers() {
        let countyDetailViewController = BlueToothSearchingTableViewController()
       // countyDetailViewController.tabBarItem = UITabBarItem(title: "bluetooth", image: , tag: 0)
       // UITabBarItem(tabBarSystemItem: UITabBarSystemItem.downloads, tag: 0)
        
        //let chatListsViewController = ChatListTableViewController()
       // chatListsViewController.tabBarItem = UITabBarItem(title: "chatRooms", image: #imageLiteral(resourceName: "living-room-books-group"), tag: 1)
        
      
    }
}


