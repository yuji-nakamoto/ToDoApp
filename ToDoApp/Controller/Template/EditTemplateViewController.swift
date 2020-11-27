//
//  EditTemplateViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import PKHUD
import GoogleMobileAds
import EmptyDataSet_Swift
import RealmSwift

class EditTemplateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    
    private var templateMemos = [TemplateMemo]()
    var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
        setSwipeBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplate()
        fetchTemplateMemo()
        setPlusImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPlusImageView()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        if templateMemos.count == 0 {
            HUD.flash(.labeledError(title: "", subtitle: "メモが作成されていません"), delay: 1)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
                
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        let templateMemos = realm.objects(TemplateMemo.self).filter("id == '\(id)'")
        
        templates.forEach { (t) in
            let alert = UIAlertController(title: "", message: "\(t.name)を\n削除してよろしいですか？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
                
                try! realm.write() {
                    realm.delete(templates)
                    realm.delete(templateMemos)
                }
                navigationController?.popViewController(animated: true)
            }
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
      
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
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
            let index = IndexPath(row: templateMemos.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func tapPlusImageView() {
        
        if UserDefaults.standard.object(forKey: "plus") == nil {
            memoTextField.becomeFirstResponder()
            UserDefaults.standard.set(true, forKey: "plus")
            plusImageView.image = UIImage(named: "cancel")
            if templateMemos.count != 0 {
                let index = IndexPath(row: templateMemos.count - 1, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        } else {
            memoTextField.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: "plus")
            plusImageView.image = UIImage(named: "plus")
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
    
    private func fetchTemplate() {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        templates.forEach { (template) in
            templateTextField.text = template.name
        }
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
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConst.constant = 0
            viewHeight.constant = 0
            viewTopConst.constant = 50
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConst.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
                viewHeight.constant = 50
                viewTopConst.constant = 10
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
        UserDefaults.standard.removeObject(forKey: "edit")
        navigationItem.title = "ひな形の編集"
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 15) as Any], for: .normal)
        tableView.tableFooterView = UIView()
        createButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        templateTextField.delegate = self
        templateTextField.returnKeyType = .next
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if templateTextField.text == "" { return false }
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("id == '\(id)'")
        
        templates.forEach { (t) in
            try! realm.write() {
                t.name = templateTextField.text!
            }
        }
        
        baseView.isHidden = false
        plusImageView.isHidden = false
        templateTextField.resignFirstResponder()
        return true
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

// MARK: - Table view

extension EditTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateMemos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateMemoTableViewCell
        
        cell.editTemplateVC = self
        cell.memoTextField.delegate = self
        cell.templateMemo = templateMemos[indexPath.row]
        cell.configureCell(templateMemos[indexPath.row])
        return cell
    }
}

extension EditTemplateViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "メモはありません", attributes: attributes)
    }
}
