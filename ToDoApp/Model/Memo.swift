//
//  Memo.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import Foundation
import RealmSwift

class Memo: Object {
    @objc dynamic var name = ""
    @objc dynamic var isCheck = false
    @objc dynamic var id = ""
}
