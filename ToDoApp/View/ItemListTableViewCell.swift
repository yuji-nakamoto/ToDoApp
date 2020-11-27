//
//  ItemListTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import RealmSwift

class ItemListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    var item = Item()
    var itemVC: ItemListViewController?
    
    func configureCell(_ item: Item) {
        itemNameLabel.text = item.name
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
