//
//  Extension.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import Foundation
import UIKit

extension UIViewController {

    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
public var itemArray = ["たまご","にんじん","たまねぎ","りんご"]
