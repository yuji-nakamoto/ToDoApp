//
//  MemoTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import RealmSwift
import WatchConnectivity

class MemoTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var memoImageView: UIImageView!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var frontView: UIView!
    
    var memo = Memo()
    var memoVC: MemoTableViewController?
    let realm = try! Realm()
    lazy var historeis2 = realm.objects(History.self)
    var watchData = String()
    let date = Date()
    let dateFormatter = DateFormatter()
    let session = WCSession.default
    var timestamp: String {
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日 (EEEEE)"
        return dateFormatter.string(from: date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapMemoImageView))
        frontView.addGestureRecognizer(tap)
        memoTextView.text = ""
        memoImageView.image = UIImage(systemName: "square")
        memoTextView.returnKeyType = .done
        
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            memoTextView.backgroundColor = UIColor(named: O_DARK1)
            memoTextView.textColor = .white
            memoImageView.tintColor = .systemBlue
        } else {
            backgroundColor = UIColor.systemBackground
            memoTextView.backgroundColor = UIColor.systemBackground
            memoTextView.textColor = .darkGray
            memoImageView.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            memoTextView.backgroundColor = UIColor(named: O_DARK1)
            memoImageView.tintColor = .systemBlue
        } else {
            backgroundColor = UIColor.systemBackground
            memoTextView.backgroundColor = UIColor.systemBackground
            memoImageView.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    // MARK: - Cell
    
    func configureCell(_ memo: Memo) {
        memoTextView.text = memo.name
        memoTextView.delegate = self
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("uid == '\(memo.uid)'")
        let historeis = realm.objects(History.self).filter("uid == '\(memo.uid)'")
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(memo.uid)'")
        let date: Double = Date().timeIntervalSince1970
        
        memos.forEach { (memo) in
            if memo.isCheck == true {
                memoImageView.image = UIImage(systemName: "square.slash")
                let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
                memoTextView.textColor = color
            } else {
                memoImageView.image = UIImage(systemName: "square")
                let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
                memoTextView.textColor = color
            }
            
            if memo.name == watchData {
                try! realm.write() {
                    memo.isCheck = true
                    memo.date = date
                }
                templateMemos.forEach { (tm) in
                    try! realm.write() {
                        tm.date = date
                    }
                }
                let history = History()
                history.name = memo.name
                history.uid = memo.uid
                history.date = date
                history.timestamp = timestamp
                let history2 = realm.objects(History.self).filter("uid == '\(history.uid)'")
                if history2.count == 0 {
                    try! realm.write() {
                        realm.add(history)
                    }
                }
            } else if memo.name + ": false" == watchData {
                try! realm.write() {
                    realm.delete(historeis)
                    memo.isCheck = false
                    memo.date = 0
                }
                templateMemos.forEach { (tm) in
                    try! realm.write() {
                        tm.date = 0
                    }
                }
            }
        }
        
        if UserDefaults.standard.object(forKey: RELOAD) == nil {
            DispatchQueue.main.async {
                self.memoVC?.tableView.reloadData()
                UserDefaults.standard.set(true, forKey: RELOAD)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("uid == '\(memo.uid)'")
        
        try! realm.write() {
            memos.forEach { (m) in
                let memos2 = realm.objects(Memo.self).filter("uid != '\(m.uid)'")
                memos2.forEach { (m2) in
                    if m.originRow < m2.originRow {
                        m2.sourceRow = m2.sourceRow - 1
                        m2.originRow = m2.originRow - 1
                    }
                }
            }
            realm.delete(memos)
            defaults.set(true, forKey: "delete")
            defaults.removeObject(forKey: EDIT_MEMO)
            memoVC?.viewWillAppear(true)
        }
    }
    
    @objc func tapMemoImageView() {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("uid == '\(memo.uid)'")
        let historeis = realm.objects(History.self).filter("uid == '\(memo.uid)'")

        historeis.forEach { (h) in
            historeis2 = realm.objects(History.self).filter("uid == '\(h.uid)'").filter("timestamp == '\(h.timestamp)'")
        }
        
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(memo.uid)'")
        let date: Double = Date().timeIntervalSince1970
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        
        memos.forEach { (memo) in
            if memoImageView.image == UIImage(systemName: "square") {
                memoImageView.image = UIImage(systemName: "square.slash")
                memoTextView.textColor = color
                generator.notificationOccurred(.success)
                
                let history = History()
                history.name = memo.name
                history.uid = memo.uid
                history.date = date
                history.timestamp = timestamp
                try! realm.write() {
                    if historeis2.count != 0 {
                        realm.add(history)
                    } else if historeis.count == 0 {
                        realm.add(history)
                    }
                    memo.isCheck = true
                    memo.date = date
                    templateMemos.forEach { (tm) in
                        tm.date = date
                    }
                }
                wcSessionUpdate()
            } else {
                let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
                memoImageView.image = UIImage(systemName: "square")
                memoTextView.textColor = color
                
                try! realm.write() {
                    templateMemos.forEach { (tm) in
                        tm.date = 0
                    }
                    memo.isCheck = false
                    memo.date = 0
                    if historeis2.count != 0 {
                        realm.delete(historeis2)
                    }
                }
                wcSessionUpdate()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func wcSessionUpdate() {
        let realm = try! Realm()
        let memoArray = realm.objects(Memo.self).sorted(byKeyPath: "sourceRow", ascending: true)
        var tableData = [String]()
        var tableData2 = [Bool]()
        memoArray.forEach { (m) in
            tableData.append(m.name)
            tableData2.append(m.isCheck)
        }
        guard WCSession.isSupported() else { return }
        do {
            try WCSession.default.updateApplicationContext(["WatchTableData": tableData, "WatchTableData2": tableData2])
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UserDefaults.standard.set(true, forKey: EDIT_MEMO)
        UserDefaults.standard.set(memo.sourceRow, forKey: SELECT_ROW)
        memoVC?.viewDidAppear(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("uid == '\(memo.uid)'")
        memos.forEach { (memo) in
            try! realm.write() {
                memo.name = memoTextView.text!
            }
        }
        wcSessionUpdate()
        memoVC?.tableView.beginUpdates()
        memoVC?.tableView.endUpdates()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            let realm = try! Realm()
            let items = realm.objects(Item.self).filter("name == '\(memoTextView.text ?? "")'")
            let item = Item()
            let uid = UUID().uuidString
            
            if items.count == 0 {
                item.name = memoTextView.text!
                item.uid = uid
                try! realm.write() {
                    realm.add(item)
                }
            }
            UserDefaults.standard.removeObject(forKey: EDIT_MEMO)
            memoTextView.resignFirstResponder()
            memoVC?.viewDidAppear(true)
            return false
        }
        return true
    }
}
