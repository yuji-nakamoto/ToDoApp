//
//  CreateTemplateViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import PKHUD
import GoogleMobileAds
import EmptyDataSet_Swift
import RealmSwift

class CreateTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    
    private var templateMemos = [TemplateMemo]()
    private let id = UUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
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
                TemplateMemo.deleteTemplateMemoId(id: id) {
                    self.navigationController?.popViewController(animated: true)
                }
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
        guard templateTextField.text != "" else { return }
        
        TemplateMemo.checkTemplateMemo(id: id) { [self] (bool) in
            if bool == true {
                HUD.flash(.labeledError(title: "", subtitle: "メモを作成していません"), delay: 1)
                return
            }
            Template.createTemplate(text: templateTextField.text!, id: id) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }

        TemplateMemo.createTemplateMemo(text: memoTextField.text!, id: id) { [self] in
            memoTextField.text = ""
            fetchTemplateMemo()
            let index = IndexPath(row: templateMemos.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func tapPlusImageView() {
        
        if UserDefaults.standard.object(forKey: CLOSE) == nil {
            UserDefaults.standard.set(true, forKey: CLOSE)
            memoTextField.becomeFirstResponder()
            plusImageView.image = UIImage(named: "cancel")
            
            if templateMemos.count != 0 {
                let index = IndexPath(row: templateMemos.count - 1, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        } else {
            UserDefaults.standard.removeObject(forKey: CLOSE)
            memoTextField.resignFirstResponder()
            plusImageView.image = UIImage(named: "plus")
        }
    }
    
    // MARK: - Fetch
    
    private func fetchTemplateMemo() {
        
        TemplateMemo.fetchTemplateMemo(id: id) { [self] (templateMemo) in
            templateMemos.removeAll()
            templateMemos.append(contentsOf: templateMemo)
            tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func setPlusImageView() {
        
        if UserDefaults.standard.object(forKey: EDIT_TEMP) != nil {
            plusImageView.isHidden = true
            baseView.isHidden = true
        } else {
            plusImageView.isHidden = false
            baseView.isHidden = false
        }
        
        if UserDefaults.standard.object(forKey: CLOSE) == nil {
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
            viewTopConst.constant = 55
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConst.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
                viewHeight.constant = 50
                viewTopConst.constant = 10
                if UserDefaults.standard.object(forKey: CLOSE) == nil {
                    viewHeight.constant = 0
                }
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
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 15) as Any], for: .normal)
        UserDefaults.standard.set(true, forKey: EDIT_TEMP)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        createButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        plusImageView.isHidden = true
        
        templateTextField.delegate = self
        templateTextField.returnKeyType = .done
        templateTextField.becomeFirstResponder()
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard templateTextField.text != "" else { return false }
        
        baseView.isHidden = false
        plusImageView.isHidden = false
        templateTextField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [self] in
            UserDefaults.standard.set(true, forKey: CLOSE)
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            plusImageView.image = UIImage(named: "cancel")
            memoTextField.becomeFirstResponder()
        }
        return true
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
        cell.memoTextView.delegate = self
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
