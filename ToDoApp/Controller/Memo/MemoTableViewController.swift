//
//  MemoTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import RealmSwift

class MemoTableViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var templateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    
    private var memoArray = [Memo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: DELETE) == nil {
            UserDefaults.standard.removeObject(forKey: CLOSE)
        }
        UserDefaults.standard.removeObject(forKey: DELETE)
        navigationController?.navigationBar.isHidden = true
        fetchTemplate()
        fetchMemo()
        setBackAction()
        setPlusImageView()
        fetchSelectedItemName()
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
        
        if UserDefaults.standard.object(forKey: CLOSE) == nil {
            UserDefaults.standard.set(true, forKey: CLOSE)
            memoTextField.becomeFirstResponder()
            plusImageView.image = UIImage(named: "cancel")
            
            if memoArray.count != 0 {
                let index = IndexPath(row: memoArray.count - 1, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
            }
            
            if UserDefaults.standard.object(forKey: ON_INPUT) != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.performSegue(withIdentifier: "ItemListVC", sender: nil)
                }
            }
            
        } else {
            memoTextField.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: CLOSE)
            plusImageView.image = UIImage(named: "plus")
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "すべて削除してよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            Memo.deleteMemos {
                memoArray.removeAll()
                tableView.reloadData()
                memoTextField.resignFirstResponder()
                UserDefaults.standard.removeObject(forKey: EDIT_MEMO)
                viewDidAppear(true)
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        Memo.checkMemosCount { [self] (bool) in
            if bool == true {
                memoTextField.resignFirstResponder()
                alert.addAction(delete)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
       fetchMemo()
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }

        Memo.createMemo(text: memoTextField.text!) { [self] in
            memoTextField.text = ""
            fetchMemo()
            let index = IndexPath(row: memoArray.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    // MARK: - Fetch
    
    private func fetchMemo() {
        
        Memo.fetchMemo { [self] (memos) in
            memoArray.removeAll()
            memoArray.append(contentsOf: memos)
            tableView.reloadData()
        }
        createTempToMemo()
    }
    
    private func createTempToMemo() {
        
        Memo.createTemplateToMemo { [self] (memo) in
            memoArray.removeAll()
            memoArray.append(memo)
            fetchTemplate()
            tableView.reloadData()
        }
    }
    
    private func fetchTemplate() {
        
        Template.fetchSelectedTemplate { [self] (bool, template) in
            if bool == true {
                templateLabel.text = "\(template.name)を選択中"
            } else {
                templateLabel.text = "ひな形未選択"
            }
        }
    }
    
    func fetchSelectedItemName() {
        Memo.selectedItemName { [self] in
            fetchMemo()
        }
    }
    
    // MARK: - Helpers
    
    private func setPlusImageView() {

        if UserDefaults.standard.object(forKey: EDIT_MEMO) != nil {
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
    
    private func setBackAction() {
        
        if UserDefaults.standard.object(forKey: BACK) != nil {
            memoTextField.resignFirstResponder()
            plusImageView.image = UIImage(named: "plus")
            UserDefaults.standard.removeObject(forKey: BACK)
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
    
    private func setup() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlusImageView))
        plusImageView.addGestureRecognizer(tap)
        navigationItem.title = "買い物メモ"
        UserDefaults.standard.removeObject(forKey: CLOSE)
        UserDefaults.standard.removeObject(forKey: EDIT_MEMO)

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        createButton.layer.cornerRadius = 5
        templateLabel.text = "ひな形未選択"
        viewHeight.constant = 0
        memoTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            topViewHeight.constant = 80
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoTextField.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: CLOSE)
        plusImageView.image = UIImage(named: "plus")
        return true
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
        cell.memoTextView.delegate = self
        cell.memo = memoArray[indexPath.row]
        cell.configureCell(memoArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   
        if editingStyle == .delete {
            UserDefaults.standard.set(true, forKey: DELETE)
            Memo.deleteMemo(id: memoArray[indexPath.row].id) { [self] in
                memoArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
                viewWillAppear(true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
}

extension MemoTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "メモはありません", attributes: attributes)
    }
}
