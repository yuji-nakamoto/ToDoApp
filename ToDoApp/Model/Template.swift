//
//  Template.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import Foundation
import RealmSwift

class Template: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var isSelect = false
    @objc dynamic var selected = false
}

class TemplateMemo: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var uid = ""
}
