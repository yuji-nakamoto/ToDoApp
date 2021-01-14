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
        let items = realm.objects(Item.self).filter("uid == '\(item.uid)'")
        
        try! realm.write() {
            realm.delete(items)
            itemVC?.viewWillAppear(true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            itemNameLabel.textColor = .white
        } else {
            backgroundColor = UIColor.systemBackground
            itemNameLabel.textColor = UIColor(named: O_BLACK)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            itemNameLabel.textColor = .white
        } else {
            backgroundColor = UIColor.systemBackground
            itemNameLabel.textColor = UIColor(named: O_BLACK)
        }
    }
}
