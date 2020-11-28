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
    
    class func fetchTemplate(id: String, completion: @escaping(Template) -> Void) {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        templates.forEach { (template) in
            completion(template)
        }
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
        
        template.id = id
        template.name = text
        try! realm.write() {
            realm.add(template)
            completion()
        }
    }
    
    class func updateTemplate(text: String, id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        
        templates.forEach { (t) in
            try! realm.write() {
                t.name = text
                completion()
            }
        }
    }
    
    class func deleteTempMemo(id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        
        templates.forEach { (t) in
            try! realm.write() {
                realm.delete(templates)
                realm.delete(templateMemos)
                completion()
            }
        }
    }
}

class TemplateMemo: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var uid = ""
    
    class func fetchTemplateMemo(id: String, completion: @escaping(Results<TemplateMemo>) -> Void) {
        let realm = try! Realm()
        let templateMemo = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        completion(templateMemo)
    }
    
    class func createTemplateMemo(text: String, id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templateMemo = TemplateMemo()
        let uid = UUID().uuidString
        
        templateMemo.id = id
        templateMemo.uid = uid
        templateMemo.name = text
        
        try! realm.write() {
            realm.add(templateMemo)
            completion()
        }
    }
    
    class func checkTemplateMemo(id: String, completion: @escaping(Bool) -> Void) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        if templateMemos.count == 0 {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    class func deleteTemplateMemoId(id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        try! realm.write() {
            realm.delete(templateMemos)
            completion()
        }
    }
    
    class func deleteTemplateMemoUid(uid: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(uid)'")
        try! realm.write() {
            realm.delete(templateMemos)
            completion()
        }
    }
}
