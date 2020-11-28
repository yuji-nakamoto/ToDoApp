//
//  Item.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    
    class func fetchItem(completion: @escaping(Int) -> Void) {
        let realm = try! Realm()
        let items = realm.objects(Item.self)
        var count: Int = 0

        if UserDefaults.standard.object(forKey: SET_ITEM) == nil {
            try! realm.write() {
                realm.delete(items)
            }
            
            itemArray.forEach { (i) in
                let item = Item()
                count += 1

                item.name = i
                item.id = String(count)
                try! realm.write() {
                    realm.add(item)
                    completion(count)
                }
            }
        }
    }
}
