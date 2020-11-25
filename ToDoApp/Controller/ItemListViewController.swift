//
//  ItemListViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import EmptyDataSet_Swift
import RealmSwift

class ItemListViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    var firstWord = ""
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItem()
    }
    
    // MARK: - Actions
    
    @objc func tapPlusImageView() {
        print("aaaaaaaa")
        UserDefaults.standard.removeObject(forKey: "plus")
        UserDefaults.standard.set(true, forKey: "back")
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
        if memoTextField.text == "" { return }
        
        let realm = try! Realm()
        let memo = Memo()
        let id = UUID().uuidString
        
        memo.id = id
        memo.text = memoTextField.text!
        try! realm.write() {
            realm.add(memo)
            memoTextField.text = ""
            UserDefaults.standard.removeObject(forKey: "plus")
            UserDefaults.standard.set(true, forKey: "back")
            navigationController?.popViewController(animated: false)
        }
    }
    
    // MARK: - Helpers
    
    private func fetchItem() {
        
        let realm = try! Realm()
        let itemArray = realm.objects(Item.self).filter("name CONTAINS '\(firstWord)'")
        items.removeAll()
        items.append(contentsOf: itemArray)
        tableView.reloadData()
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
    
    @objc func textFieldDidChange() {
        
        let realm = try! Realm()
        let itemArray = realm.objects(Item.self).filter("name CONTAINS '\(memoTextField.text ?? "")'")
        items.removeAll()
        items.append(contentsOf: itemArray)
        tableView.reloadData()
    }
    
    private func setup() {
        
        memoTextField.text = firstWord
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlusImageView))
        plusImageView.addGestureRecognizer(tap)
        navigationItem.title = "買い物メモ"

        tableView.tableFooterView = UIView()
        createButton.layer.cornerRadius = 5
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        memoTextField.delegate = self
        memoTextField.becomeFirstResponder()
        memoTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        UserDefaults.standard.set(true, forKey: "back")
        UserDefaults.standard.removeObject(forKey: "plus")
        navigationController?.popViewController(animated: false)
        return true
    }
}

// MARK: - Table view

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemListTableViewCell
        let itemName = cell.viewWithTag(1) as! UILabel
        
        cell.itemVC = self
        cell.item = items[indexPath.row]
        itemName.text = items[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            UserDefaults.standard.set(items[indexPath.row].name, forKey: "itemName")
            navigationController?.popViewController(animated: false)
            UserDefaults.standard.removeObject(forKey: "plus")
            UserDefaults.standard.set(true, forKey: "back")
        }
    }
}

extension ItemListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "入力候補はありません", attributes: attributes)
    }
}
