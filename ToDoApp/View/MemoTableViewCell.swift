//
//  MemoTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import RealmSwift

class MemoTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var fronView: UIView!
    
    var memo = Memo()
    var memoVC: MemoTableViewController?
    
    func configureCell(_ memo: Memo) {
        memoTextView.text = memo.name
        memoTextView.delegate = self
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        memos.forEach { (memo) in
            if memo.isCheck == true {
                memoImageView.image = UIImage(systemName: "square.slash")
                memoTextView.textColor = .systemGray3
            } else {
                memoImageView.image = UIImage(systemName: "square")
                memoTextView.textColor = UIColor(named: O_BLACK)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMemoImageView))
        fronView.addGestureRecognizer(tap)
        memoTextView.text = ""
        memoImageView.image = UIImage(systemName: "square")
        memoTextView.returnKeyType = .done
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        try! realm.write() {
            realm.delete(memos)
            UserDefaults.standard.removeObject(forKey: EDIT_MEMO)
            memoVC?.viewWillAppear(true)
        }
    }
    
    @objc func tapMemoImageView() {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
        
        memos.forEach { (memo) in
            if memoImageView.image == UIImage(systemName: "square") {
                memoImageView.image = UIImage(systemName: "square.slash")
                memoTextView.textColor = .systemGray3
                if UserDefaults.standard.object(forKey: ON_CHECK) != nil {
                    generator.notificationOccurred(.success)
                }
                try! realm.write() {
                    memo.isCheck = true
                }
            } else {
                memoImageView.image = UIImage(systemName: "square")
                memoTextView.textColor = UIColor(named: O_BLACK)
                try! realm.write() {
                    memo.isCheck = false
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UserDefaults.standard.set(true, forKey: EDIT_MEMO)
        memoVC?.viewDidAppear(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        memoVC?.tableView.beginUpdates()
        memoVC?.tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if memoTextView.text == "" { return false }
        
        if text == "\n" {
            let realm = try! Realm()
            let memos = realm.objects(Memo.self).filter("id == '\(memo.id)'")
            let items = realm.objects(Item.self).filter("name == '\(memoTextView.text ?? "")'")
            let item = Item()
            let id = UUID().uuidString
            
            if items.count == 0 {
                memos.forEach { (memo) in
                    item.name = memoTextView.text!
                    item.id = id
                    try! realm.write() {
                        realm.add(item)
                        memo.name = memoTextView.text!
                    }
                }
            }
            UserDefaults.standard.removeObject(forKey: EDIT_MEMO)
            UserDefaults.standard.removeObject(forKey: CLOSE)
            memoTextView.resignFirstResponder()
            memoVC?.viewDidAppear(true)
            return false
        }
        return true
    }
}
