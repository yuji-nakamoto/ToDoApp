//
//  MyTabBarController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/12/04.
//

import UIKit

class MyTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            tabBar.barTintColor = UIColor(named: EMERALD_GREEN)
            tabBar.tintColor = UIColor.white
            tabBar.unselectedItemTintColor = UIColor.systemGray3
        } else {
            tabBar.barTintColor = UIColor(named: O_WHITE)
            tabBar.tintColor = UIColor(named: EMERALD_GREEN)
            tabBar.unselectedItemTintColor = UIColor.systemGray
        }
    }
}
