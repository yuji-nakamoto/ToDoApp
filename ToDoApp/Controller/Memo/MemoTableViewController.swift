//
//  MemoTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import EmptyDataSet_Swift
import RealmSwift

class MemoTableViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var templateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    private var memoArray = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setItem()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memoTextField.text = ""
        UserDefaults.standard.removeObject(forKey: "plus")
        UserDefaults.standard.removeObject(forKey: "next")
        navigationController?.navigationBar.isHidden = true
        fetchTemplate()
        fetchMemo()
        setBackAction()
        setPlusImageView()
        selectedItemName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPlusImageView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @objc func tapPlusImageView() {
        
        if UserDefaults.standard.object(forKey: "plus") == nil {
            memoTextField.becomeFirstResponder()
            UserDefaults.standard.set(true, forKey: "plus")
            plusImageView.image = UIImage(named: "cancel")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "ItemListVC", sender: nil)
            }
        } else {
            memoTextField.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: "plus")
            plusImageView.image = UIImage(named: "plus")
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "すべて削除してよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            let realm = try! Realm()
            let memos = realm.objects(Memo.self)
            
            try! realm.write() {
                realm.delete(memos)
                memoArray.removeAll()
                tableView.reloadData()
                memoTextField.resignFirstResponder()
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let realm = try! Realm()
        let memos = realm.objects(Memo.self)
        
        if memos.count != 0 {
            memoTextField.resignFirstResponder()
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch
    
    func fetchMemo() {
        
        let realm = try! Realm()
        let memos = realm.objects(Memo.self)
        let templates = realm.objects(Template.self).filter("isSelect == true")

        memoArray.removeAll()
        memoArray.append(contentsOf: memos)
        tableView.reloadData()
        
        if templates.count == 1 {
            try! realm.write {
                realm.delete(memos)
                memoArray.removeAll()
            }
            templates.forEach { (t) in
                let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(t.id)'")
                
                templateMemos.forEach { (tm) in
                    let memo = Memo()
                    memo.name = tm.name
                    memo.id = tm.uid
                    try! realm.write() {
                        realm.add(memo)
                        t.isSelect = false
                        t.selected = true
                        fetchTemplate()
                    }
                    memoArray.append(memo)
                    tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchTemplate() {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("selected == true")
        
        if templates.count == 1 {
            templates.forEach { (template) in
                templateLabel.text = "\(template.name)を選択中"
            }
        } else {
            templateLabel.text = "ひな形未選択"
        }
    }
    
    // MARK: - Helpers

    func selectedItemName() {
        
        if UserDefaults.standard.object(forKey: "itemName") != nil {
            let itemName = UserDefaults.standard.object(forKey: "itemName") as! String
            UserDefaults.standard.removeObject(forKey: "itemName")
            let realm = try! Realm()
            let memo = Memo()
            let id = UUID().uuidString
            
            memo.id = id
            memo.name = itemName
            try! realm.write() {
                realm.add(memo)
                fetchMemo()
            }
        }
    }
    
    private func setItem() {
        
        let realm = try! Realm()
        let items = realm.objects(Item.self)
        
        if UserDefaults.standard.object(forKey: "itemSet") == nil {
            try! realm.write() {
                realm.delete(items)
            }
            
            itemArray.forEach { (i) in
                let item = Item()
                let id = UUID().uuidString
                
                item.name = i
                item.id = id
                try! realm.write() {
                    realm.add(item)
                    UserDefaults.standard.set(true, forKey: "itemSet")
                }
            }
        } 
    }
    
    private func setPlusImageView() {

        if UserDefaults.standard.object(forKey: "edit") != nil {
            plusImageView.isHidden = true
            baseView.isHidden = true
        } else {
            plusImageView.isHidden = false
            baseView.isHidden = false
        }
        
        if UserDefaults.standard.object(forKey: "plus") == nil {
            plusImageView.image = UIImage(named: "plus")
        } else {
            plusImageView.image = UIImage(named: "cancel")
        }
    }
    
    private func setBackAction() {
        
        if UserDefaults.standard.object(forKey: "back") != nil {
            memoTextField.resignFirstResponder()
            plusImageView.image = UIImage(named: "plus")
            UserDefaults.standard.removeObject(forKey: "back")
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConst.constant = 0
            viewHeight.constant = 0
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConst.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
                viewHeight.constant = 50
            } else {
                viewBottomConst.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    private func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlusImageView))
        plusImageView.addGestureRecognizer(tap)
        navigationItem.title = "買い物メモ"
        UserDefaults.standard.removeObject(forKey: "plus")
        UserDefaults.standard.removeObject(forKey: "edit")
        templateLabel.text = "ひな形未選択"

        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        createButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        
        memoTextField.delegate = self
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoTextField.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: "plus")
        plusImageView.image = UIImage(named: "plus")
        return true
    }
}

// MARK: - Table view

extension MemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MemoTableViewCell
        
        cell.memoVC = self
        cell.memoTextField.delegate = self
        cell.memo = memoArray[indexPath.row]
        cell.configureCell(memoArray[indexPath.row])
        return cell
    }
}

extension MemoTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "メモはありません", attributes: attributes)
    }
}
