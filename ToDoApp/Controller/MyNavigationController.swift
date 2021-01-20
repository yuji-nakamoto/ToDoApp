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
    }
    
    override open var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }
}
