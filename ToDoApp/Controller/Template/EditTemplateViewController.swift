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

class EditTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    private var templateMemos = [TemplateMemo]()
    var id = UserDefaults.standard.object(forKey: ID) as! String
    
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
        fetchTemplate()
        fetchTemplateMemo()
        baseViewHidden()
        selectColor()
        setColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        baseViewHidden()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        TemplateMemo.checkTemplateMemo(id: id) { (bool) in
            if bool == true {
                HUD.flash(.labeledError(title: "", subtitle: "メモが作成されていません"), delay: 1)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "ひな形を\n削除してよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            TemplateMemo.deleteTempMemo(id: id) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dismiss(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        memoTextField.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: CLOSE)
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
    
    @objc func tapPlusImageView() {
        
        UserDefaults.standard.set(true, forKey: CLOSE)
        memoTextField.becomeFirstResponder()
        
        if templateMemos.count != 0 {
            let index = IndexPath(row: templateMemos.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
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
    
    private func fetchTemplate() {
        Template.fetchTemplate(id: id) { [self] (template) in
            templateTextField.text = template.name
        }
    }
    
    // MARK: - Helpers
    
    private func baseViewHidden() {
        
        if UserDefaults.standard.object(forKey: EDIT_TEMP) != nil {
            baseView.isHidden = true
        } else {
            baseView.isHidden = false
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
        UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
        navigationItem.title = "ひな形の編集"
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Helvetica Bold", size: 15) as Any], for: .normal)
        createButton.layer.cornerRadius = 5
        closeButton.layer.cornerRadius = 5
        viewHeight.constant = 0
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        templateTextField.delegate = self
        templateTextField.returnKeyType = .done
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        print(UIScreen.main.nativeBounds.height)
        switch UIScreen.main.nativeBounds.height {
        case 1334:
            bannerHeight.constant = 50
        case 2208:
            bannerHeight.constant = 50
        default:
            break
        }
    }
    
    private func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            deleteButton.tintColor = UIColor.white
            dismissButton.tintColor = UIColor.white
        } else {
            titleLabel.textColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            deleteButton.tintColor = UIColor.systemGray
            dismissButton.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard templateTextField.text != "" else { return false }
        if templateTextField.text!.count >= 16 {
            HUD.flash(.labeledError(title: "", subtitle: "15文字以内で入力してください"), delay: 1)
            return false
        }
        
        Template.updateTemplate(text: templateTextField.text!, id: id) { [self] in
            baseView.isHidden = false
            plusImageView.isHidden = false
            templateTextField.resignFirstResponder()
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

extension EditTemplateViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [dragItem(for: indexPath)]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
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

extension EditTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateMemos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateMemoTableViewCell
        
        cell.editTemplateVC = self
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

extension EditTemplateViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "メモはありません", attributes: attributes)
    }
}

extension EditTemplateViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
