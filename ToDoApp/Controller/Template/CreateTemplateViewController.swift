//
//  CreateTemplateViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import PKHUD
import EmptyDataSet_Swift
import RealmSwift

class CreateTemplateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    private var templateMemos = [TemplateMemo]()
    private let id = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplateMemo()
        setPlusImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPlusImageView()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        if templateTextField.text != "" {
            let alert = UIAlertController(title: "", message: "保存していません\n戻ってもよろしいですか？", preferredStyle: .alert)
            let back = UIAlertAction(title: "戻る", style: UIAlertAction.Style.default) { [self] (alert) in
                navigationController?.popViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(back)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        
        if templateTextField.text == "" { return }
        
        let realm = try! Realm()
        let template = Template()
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        
        if templateMemos.count == 0 {
            HUD.flash(.labeledError(title: "", subtitle: "メモを作成していません"), delay: 1)
            return
        }
        
        template.id = id
        template.name = templateTextField.text!
        try! realm.write() {
            realm.add(template)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
        if memoTextField.text == "" { return }
        
        let realm = try! Realm()
        let templateMemo = TemplateMemo()
        let uid = UUID().uuidString
        
        templateMemo.id = id
        templateMemo.uid = uid
        templateMemo.name = memoTextField.text!
        
        try! realm.write() {
            realm.add(templateMemo)
            memoTextField.text = ""
            fetchTemplateMemo()
        }
    }
    
    // MARK: - Fetch
    
    private func fetchTemplateMemo() {
        
        let realm = try! Realm()
        let templateMemo = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        
        templateMemos.removeAll()
        templateMemos.append(contentsOf: templateMemo)
        tableView.reloadData()
    }
    
    // MARK: - Helpers
    
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
    
    @objc func tapPlusImageView() {
        
        if UserDefaults.standard.object(forKey: "plus") == nil {
            memoTextField.becomeFirstResponder()
            UserDefaults.standard.set(true, forKey: "plus")
            plusImageView.image = UIImage(named: "cancel")
        } else {
            memoTextField.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: "plus")
            plusImageView.image = UIImage(named: "plus")
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
                viewBottomConst.constant = view.safeAreaInsets.bottom + keyboardViewEndFrame.height - 165
                viewHeight.constant = 50
            } else {
                viewBottomConst.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldBeginEditing() {
        baseView.isHidden = true
        plusImageView.isHidden = true
    }
    
    private func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlusImageView))
        plusImageView.addGestureRecognizer(tap)
        navigationItem.title = "ひな形の作成"
        UserDefaults.standard.set(true, forKey: "edit")
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        createButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        plusImageView.isHidden = true
        
        templateTextField.delegate = self
        templateTextField.returnKeyType = .next
        templateTextField.becomeFirstResponder()
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if templateTextField.text == "" { return false }
        
        baseView.isHidden = false
        plusImageView.isHidden = false
        templateTextField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
            UserDefaults.standard.set(true, forKey: "plus")
            UserDefaults.standard.removeObject(forKey: "edit")
            plusImageView.image = UIImage(named: "cancel")
            memoTextField.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - Table view

extension CreateTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateMemos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateMemoTableViewCell
     
        cell.createTemplateVC = self
        cell.memoTextField.delegate = self
        cell.templateMemo = templateMemos[indexPath.row]
        cell.configureCell(templateMemos[indexPath.row])
        return cell
    }
}

extension CreateTemplateViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "メモはありません", attributes: attributes)
    }
}
