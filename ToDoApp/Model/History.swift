//
//  History.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/30.
//

import Foundation
import RealmSwift

class History: Object {
    @objc dynamic var name = ""
    @objc dynamic var timestamp = ""
    @objc dynamic var date: Double = 0
    @objc dynamic var uid = ""
}
