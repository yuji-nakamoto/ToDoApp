//
//  CreateTemplateViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import PKHUD
import GoogleMobileAds
import RealmSwift

class CreateTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    private var templateMemos = [TemplateMemo]()
    private let id = UUID().uuidString
    private var allowMove = false
    private var forbidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplateMemo()
        selectColor()
        setColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: EDIT_TEMP) != nil {
            baseViewIsHidden()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        baseView.isHidden = false
        memoTextField.becomeFirstResponder()
        
        if templateMemos.count != 0 {
            let index = IndexPath(row: templateMemos.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "保存していない場合、\nデータが消去されます", message: "戻ってもよろしいですか？", preferredStyle: .alert)
        let back = UIAlertAction(title: "戻る", style: UIAlertAction.Style.default) { [self] (alert) in
            TemplateMemo.deleteTemplateMemoId(id: id) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
        alert.addAction(back)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func completionButtonTapped(_ sender: Any) {
        guard templateTextField.text != "" else {
            HUD.flash(.labeledError(title: "", subtitle: "ひな形の名前を作成していません"), delay: 1)
            return
        }
        
        Template.createTemplate(text: templateTextField.text!, id: id) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        memoTextField.resignFirstResponder()
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }
        if let text = memoTextField.text {
            TemplateMemo.createTemplateMemo(text: text, id: id) { [self] in
                memoTextField.text = ""
                fetchTemplateMemo()
                let index = IndexPath(row: templateMemos.count - 1, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    
    // MARK: - Fetch
    
    private func fetchTemplateMemo() {
        
        TemplateMemo.fetchTemplateMemo(id: id) { [self] (templateMemo) in
            if templateMemo.count == 0 { saveButton.isEnabled = false }
            templateMemo.forEach { (t) in
                if t.templateId != "" {
                    saveButton.isEnabled = true
                }
            }
            templateMemos.removeAll()
            templateMemos.append(contentsOf: templateMemo)
            tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    private func baseViewIsHidden() {
        
        if UserDefaults.standard.object(forKey: EDIT_TEMP) != nil {
            baseView.isHidden = true
            viewHeight.constant = 0
        } else {
            baseView.isHidden = false
            viewHeight.constant = 50
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
    
    @objc func textFieldBeginEditing() {
        baseView.isHidden = true
    }
    
    private func setup() {
        navigationItem.title = "ひな形の作成"
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 15) as Any], for: .normal)
        UserDefaults.standard.set(true, forKey: EDIT_TEMP)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        createButton.layer.cornerRadius = 5
        closeButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        saveButton.isEnabled = false
        
        templateTextField.delegate = self
        templateTextField.returnKeyType = .done
        templateTextField.becomeFirstResponder()
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            saveButton.tintColor = UIColor.white
            backButton.tintColor = UIColor.white
        } else {
            saveButton.tintColor = UIColor(named: EMERALD_GREEN)
            backButton.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard templateTextField.text != "" else { return false }
        if templateTextField.text!.count >= 16 {
            HUD.flash(.labeledError(title: "", subtitle: "15文字以内で入力してください"), delay: 1)
            return false
        }
        
        baseView.isHidden = false
        templateTextField.resignFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            memoTextField.becomeFirstResponder()
        }
        return true
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let tempName = templateMemos[indexPath.row].name
        let itemProvider = NSItemProvider(object: tempName as NSString)
        
        return UIDragItem(itemProvider: itemProvider)
    }
    
    func moveItem(sourcePath: Int, destinationPath: Int) {
        let temps = templateMemos.remove(at: sourcePath)
        templateMemos.insert(temps, at: destinationPath)
    }
}

// MARK: - Table view

extension CreateTemplateViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row != templateMemos.count else {
            forbidden = true
            return []
        }
        forbidden = false
        return [dragItem(for: indexPath)]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let realm = try! Realm()
        let tempMemos = realm.objects(TemplateMemo.self)
            .sorted(byKeyPath: "sourceRow", ascending: true).filter("templateId == '\(id)'")
        
        if forbidden {
            return UITableViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
        
        tempMemos.forEach { (tm) in
            let allow = destinationIndexPath?.row == nil || destinationIndexPath!.row >= tm.sourceRow + 1 ? false : true
            allowMove = allow
        }
        
        let operation: UIDropOperation = allowMove ? .move : .cancel
        return UITableViewDropProposal(operation: operation, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let item = coordinator.items.first,
              let destinationIndexPath = coordinator.destinationIndexPath,
              let sourceIndexPath = item.sourceIndexPath else { return }
        
        tableView.performBatchUpdates({ [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.moveItem(sourcePath: sourceIndexPath.row, destinationPath: destinationIndexPath.row)
            tableView.deleteRows(at: [sourceIndexPath], with: .automatic)
            tableView.insertRows(at: [destinationIndexPath], with: .automatic)
        }, completion: nil)
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
}

extension CreateTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateMemos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateMemoTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        
        if indexPath.row == templateMemos.count {
            return cell2!
        }
        
        cell.createTemplateVC = self
        cell.memoTextView.delegate = self
        cell.templateMemo = templateMemos[indexPath.row]
        cell.configureCell(templateMemos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tempMemo = templateMemos[sourceIndexPath.row]
        templateMemos.remove(at: sourceIndexPath.row)
        templateMemos.insert(tempMemo, at: destinationIndexPath.row)
        
        if sourceIndexPath.row == destinationIndexPath.row { return }

        print("-------start-------")
        let realm = try! Realm()
        let tempMemos = realm.objects(TemplateMemo.self)
            .filter("sourceRow == \(sourceIndexPath.row)").filter("templateId == '\(id)'")
        tempMemos.forEach { (t) in

            try! realm.write() {
                t.sourceRow = destinationIndexPath.row
                t.sorted = true
                let tempMemos2 = realm.objects(TemplateMemo.self)
                    .filter("sorted == false").filter("templateId == '\(id)'")
                tempMemos2.forEach { (t2) in

                    if t.sourceRow > t2.sourceRow {
                        if t.originRow > t2.sourceRow {
                            print("stay1: ", t2.name)
                        } else {
                            t2.sourceRow = t2.sourceRow - 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
                            print("minus: ", t2.name)
                        }

                    } else if t.sourceRow < t2.sourceRow {
                        if t.originRow < t2.sourceRow {
                            print("stay2: ", t2.name)
                        } else {
                            t2.sourceRow = t2.sourceRow + 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
                            print("plus: ", t2.name)
                        }
                    } else if t.sourceRow == t2.sourceRow {
                        if t.originRow < t2.sourceRow {
                            t2.sourceRow = t2.sourceRow - 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
                            print("== minus: ", t2.name)
                        } else if t.originRow > t2.sourceRow {
                            t2.sourceRow = t2.sourceRow + 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
                            print("== plus: ", t2.name)
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        try! realm.write() {
                            t.sorted = false
                        }
                    }
                }
            }
        }
    }
}
