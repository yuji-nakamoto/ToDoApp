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
    @objc dynamic var sourceRow = 0
    @objc dynamic var originRow = 0
    @objc dynamic var sorted = false
    @objc dynamic var date: Double = 0
    @objc dynamic var isCheck = false
    @objc dynamic var uid = ""
    @objc dynamic var templateId = ""
    
    class func fetchMemo(sort: Bool, completion: @escaping(Results<Memo>) -> Void) {
        let realm = try! Realm()
        if sort == false {
            let memos = realm.objects(Memo.self).sorted(byKeyPath: "sourceRow", ascending: true)
            completion(memos)
        } else {
            let memos = realm.objects(Memo.self).sorted(byKeyPath: "isCheck", ascending: true)
            completion(memos)
        }
    }
    
    class func createMemo(text: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let item = Item()
        let memo = Memo()
        let memos = realm.objects(Memo.self)
        let uid = UUID().uuidString
        
        item.uid = uid
        item.name = text
        memo.uid = uid
        memo.name = text
        
        if memos.count != 0 {
            memo.sourceRow = memos.count
            memo.originRow = memos.count
        }
        
        try! realm.write() {
            realm.add(item)
            realm.add(memo)
            completion()
        }
    }
    
    class func createTemplateToMemo(completion: @escaping([Memo]) -> Void) {
        
        var memoArray = [Memo]()
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "isCheck", ascending: true)
        let templates = realm.objects(Template.self).filter("isSelect == true")
        
        if templates.count == 1 {
            
            templates.forEach { (t) in
                let templateMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(t.templateId)'")
                guard templateMemos.count != 0 else { return }
                
                try! realm.write {
                    realm.delete(memos)
                }
                
                templateMemos.forEach { (tm) in
                    let memo = Memo()
                    memo.name = tm.name
                    memo.uid = tm.uid
                    memo.date = tm.date
                    memo.templateId = tm.templateId
                    memo.sourceRow = tm.sourceRow
                    memo.originRow = tm.originRow
                    try! realm.write() {
                        realm.add(memo)
                        t.isSelect = false
                        t.selected = true
                        memoArray.append(memo)
                        completion(memoArray)
                    }
                }
            }
        }
    }
    
    class func checkMemosCount(completion: @escaping(Bool) -> Void) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self)
        
        if memos.count != 0 {
            completion(true)
        }
    }
    
    class func selectedItemName(completion: @escaping() -> Void) {
        
        if UserDefaults.standard.object(forKey: ITEM_NAME) != nil {
            let itemName = UserDefaults.standard.object(forKey: ITEM_NAME) as! String
            let realm = try! Realm()
            let memo = Memo()
            let memos = realm.objects(Memo.self)
            let uid = UUID().uuidString
            UserDefaults.standard.removeObject(forKey: ITEM_NAME)
            
            memo.uid = uid
            memo.name = itemName
            
            if memos.count != 0 {
                memo.sourceRow = memos.count
                memo.originRow = memos.count
            }
            
            try! realm.write() {
                realm.add(memo)
                completion()
            }
        }
    }
    
    class func deleteMemos(completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self)
        
        try! realm.write() {
            realm.delete(memos)
            completion()
        }
    }
    
    class func deleteMemo(id: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("uid == '\(id)'")
        
        try! realm.write() {
            realm.delete(memos)
            completion()
        }
    }
}
