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
    
    class func fetchMemo(completion: @escaping(Results<Memo>) -> Void) {
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "isCheck", ascending: true)
        completion(memos)
    }
    
    class func createMemo(text: String, completion: @escaping() -> Void) {
        
        let realm = try! Realm()
        let item = Item()
        let memo = Memo()
        let id = UUID().uuidString
        
        item.id = id
        item.name = text
        
        memo.id = id
        memo.name = text
        try! realm.write() {
            realm.add(item)
            realm.add(memo)
            completion()
        }
    }
    
    class func createTemplateToMemo(completion: @escaping(Memo) -> Void) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "isCheck", ascending: true)
        let templates = realm.objects(Template.self).filter("isSelect == true")
        
        if templates.count == 1 {
            
            templates.forEach { (t) in
                let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(t.id)'")
                
                if templateMemos.count == 0 { return }
                
                try! realm.write {
                    realm.delete(memos)
                }
                
                templateMemos.forEach { (tm) in
                    let memo = Memo()
                    memo.name = tm.name
                    memo.id = tm.uid
                    try! realm.write() {
                        realm.add(memo)
                        t.isSelect = false
                        t.selected = true
                        completion(memo)
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
            let id = UUID().uuidString
            UserDefaults.standard.removeObject(forKey: ITEM_NAME)
            
            memo.id = id
            memo.name = itemName
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
        let memos = realm.objects(Memo.self).filter("id == '\(id)'")
        
        try! realm.write() {
            realm.delete(memos)
            completion()
        }
    }
}
