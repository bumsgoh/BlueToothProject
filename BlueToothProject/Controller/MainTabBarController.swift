//
//  MainTabBarController.swift
//
//  BlueToothProject
//  Created by 고상범 on 2018. 10. 6..
//  Copyright © 2018년 고상범. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var userId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.isNavi
        self.view.backgroundColor = UIColor.white
        makeViewControllers()
    }
    func makeViewControllers() {
        let blueToothVC = BlueToothSearchingTableViewController()
        blueToothVC.tabBarItem = UITabBarItem(title: "bluetooth", image: #imageLiteral(resourceName: "bluetooth-logo-with-background"), tag: 0)
       // UITabBarItem(tabBarSystemItem: UITabBarSystemItem.downloads, tag: 0)
        let naviCoverBlueTooth: UINavigationController = UINavigationController(rootViewController: blueToothVC)
        let connectingBTVC: ConnectedBlueToothViewController = ConnectedBlueToothViewController()
         connectingBTVC.tabBarItem = UITabBarItem(title: "bluetooth", image: #imageLiteral(resourceName: "bluetooth-logo-with-background"), tag: 0)
        
        let chatListsViewController = ChatListTableViewController()
        chatListsViewController.userId = self.userId
        chatListsViewController.tabBarItem = UITabBarItem(title: "chatRooms", image: #imageLiteral(resourceName: "living-room-books-group"), tag: 1)
        
        let naviCover: UINavigationController = UINavigationController(rootViewController: chatListsViewController)
        setViewControllers([connectingBTVC, chatListsViewController], animated: false)
      
    }
}


