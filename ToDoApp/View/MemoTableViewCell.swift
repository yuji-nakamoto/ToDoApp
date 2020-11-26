//
//  MemoTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import RealmSwift

class MemoTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var memo = Memo()
    var memoVC: MemoTableViewController?
    
    func configureCell(_ memo: Memo) {
        memoTextField.text = memo.name
        memoTextField.delegate = self
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        memos.forEach { (memo) in
            if memo.isCheck == true {
                memoImageView.image = UIImage(systemName: "square.slash")
                memoTextField.textColor = .systemGray3
            } else {
                memoImageView.image = UIImage(systemName: "square")
                memoTextField.textColor = UIColor(named: O_BLACK)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMemoImageView))
        memoImageView.addGestureRecognizer(tap)
        memoTextField.text = ""
        memoImageView.image = UIImage(systemName: "square")
        memoTextField.returnKeyType = .done
        memoTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        try! realm.write() {
            realm.delete(memos)
            memoVC?.viewWillAppear(true)
        }
    }
    
    @objc func textFieldBeginEditing() {
        UserDefaults.standard.set(true, forKey: "edit")
        memoVC?.viewDidAppear(true)
    }
    
    @objc func tapMemoImageView() {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        memos.forEach { (memo) in
            if memoImageView.image == UIImage(systemName: "square") {
                memoImageView.image = UIImage(systemName: "square.slash")
                memoTextField.textColor = .systemGray3
                try! realm.write() {
                    memo.isCheck = true
                }
            } else {
                memoImageView.image = UIImage(systemName: "square")
                memoTextField.textColor = UIColor(named: O_BLACK)
                try! realm.write() {
                    memo.isCheck = false
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if memoTextField.text == "" { return false }
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        let items = realm.objects(Item.self).filter("name == '\(memoTextField.text ?? "")'")
        let item = Item()
        let id = UUID().uuidString
        
        if items.count == 0 {
            memos.forEach { (memo) in

                item.name = memoTextField.text!
                item.id = id
                try! realm.write() {
                    realm.add(item)
                    memo.name = memoTextField.text!
                }
            }
        }
        
        UserDefaults.standard.removeObject(forKey: "edit")
        UserDefaults.standard.removeObject(forKey: "plus")
        memoTextField.resignFirstResponder()
        memoVC?.viewDidAppear(true)
        return true
    }
}
