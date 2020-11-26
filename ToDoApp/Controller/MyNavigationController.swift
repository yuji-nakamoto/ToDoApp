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
        navigationBar.titleTextAttributes
            = [.foregroundColor: UIColor(named: O_BLACK) as Any,]
    }
}
