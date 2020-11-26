//
//  ItemListTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import RealmSwift

class ItemListTableViewCell: UITableViewCell {
    
    var item = Item()
    var itemVC: ItemListViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let items = realm.objects(Item.self).filter("id == '\(item.id)'")
        
        try! realm.write() {
            realm.delete(items)
            itemVC?.viewWillAppear(true)
        }
    }
}
