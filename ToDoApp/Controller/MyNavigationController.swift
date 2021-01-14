//
//  MyNavigationController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            navigationBar.barTintColor = UIColor(named: EMERALD_GREEN_ALPHA)
            navigationBar.titleTextAttributes
                = [.foregroundColor: UIColor.white as Any,]
        } else {
            navigationBar.barTintColor = UIColor(named: O_WHITE_ALPHA)
            navigationBar.titleTextAttributes
                = [.foregroundColor: UIColor(named: O_BLACK) as Any,]
        }
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }
}
