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
    @objc dynamic var sourceRow = 0
    @objc dynamic var originRow = 0
    @objc dynamic var sorted = false
    @objc dynamic var templateId = ""
    @objc dynamic var isSelect = false
    @objc dynamic var selected = false
    
    class func fetchTemplate(id: String, completion: @escaping(Template) -> Void) {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("templateId == '\(id)'")
        templates.forEach { (template) in
            completion(template)
        }
    }
    
    class func updateSelected(completion: @escaping(Results<Template>) -> Void) {
        
        let realm = try! Realm()
        let templateArray = realm.objects(Template.self).sorted(byKeyPath: "sourceRow", ascending: true)
 
        templateArray.forEach { (t) in
            try! realm.write() {
                t.selected = false
                completion(templateArray)
            }
        }
        completion(templateArray)
    }
    
    class func fetchSelectedTemplate(completion: @escaping(Bool, Template) -> Void) {
        
        let realm = try! Realm()
        let template = Template()
        let templates = realm.objects(Template.self).filter("selected == true")
        
        if templates.count == 1 {
            templates.forEach { (template) in
                completion(true, template)
            }
        } else {
            completion(false, template)
        }
    }
    
    class func createTemplate(text: String, id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let template = Template()
        let temps = realm.objects(Template.self)
        
        template.templateId = id
        template.name = text
        template.sourceRow = temps.count
        template.originRow = temps.count
        
        try! realm.write() {
            realm.add(template)
            completion()
        }
    }
    
    class func updateTemplate(text: String, id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("templateId == '\(id)'")
        
        templates.forEach { (t) in
            try! realm.write() {
                t.name = text
                completion()
            }
        }
    }
}

class TemplateMemo: Object {
    @objc dynamic var name = ""
    @objc dynamic var sourceRow = 0
    @objc dynamic var originRow = 0
    @objc dynamic var sorted = false
    @objc dynamic var date: Double = 0
    @objc dynamic var templateId = ""
    @objc dynamic var uid = ""
    
    class func fetchTemplateMemo(id: String, completion: @escaping(Results<TemplateMemo>) -> Void) {
        let realm = try! Realm()
        let templateMemo = realm.objects(TemplateMemo.self).filter("templateId == '\(id)'").sorted(byKeyPath: "sourceRow", ascending: true)
        completion(templateMemo)
    }
    
    class func createTemplateMemo(text: String, id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let tempMemo = TemplateMemo()
        let tempMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(id)'")
        let uid = UUID().uuidString
        
        tempMemo.templateId = id
        tempMemo.uid = uid
        tempMemo.name = text
        
        if tempMemos.count != 0 {
            tempMemo.sourceRow = tempMemos.count
            tempMemo.originRow = tempMemos.count
        }
        
        try! realm.write() {
            realm.add(tempMemo)
            completion()
        }
    }
    
    class func checkTemplateMemo(id: String, completion: @escaping(Bool) -> Void) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(id)'")
        if templateMemos.count == 0 {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    class func deleteTemplateMemoId(id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(id)'")
        try! realm.write() {
            realm.delete(templateMemos)
            completion()
        }
    }
    
    class func deleteTemplateMemoUid(uid: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let tempMemos = realm.objects(TemplateMemo.self).filter("uid == '\(uid)'")
        
        try! realm.write() {
            tempMemos.forEach { (t) in
                let tempMemos2 = realm.objects(TemplateMemo.self).filter("templateId == '\(t.templateId)'")
                tempMemos2.forEach { (t2) in
                    if t.originRow < t2.originRow {
                        t2.sourceRow = t2.sourceRow - 1
                        t2.originRow = t2.originRow - 1
                    }
                }
            }
            realm.delete(tempMemos)
            completion()
        }
    }
    
    class func deleteTempMemo(id: String, completion: @escaping() -> Void) {
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("templateId == '\(id)'")
        let allTemplate = realm.objects(Template.self)
        let templateMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(id)'")
        
        templates.forEach { (t) in
            try! realm.safeWrite {
                allTemplate.forEach { (at) in
                    if t.sourceRow < at.sourceRow {
                        at.sourceRow = at.sourceRow - 1
                        at.originRow = at.originRow - 1
                    }
                }
                realm.delete(templateMemos)
                realm.delete(templates)
                completion()
            }
        }
    }
}
