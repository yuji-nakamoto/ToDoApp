//
//  EditTemplateViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import PKHUD
import GoogleMobileAds
import RealmSwift

class EditTemplateViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var topBaseView: UIView!
    @IBOutlet weak var memoListView: UIView!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var templateTextField: UITextField!
    @IBOutlet weak var tempNameLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    private var templateMemos = [TemplateMemo]()
    private var allowMove = false
    private var forbidden = false
    private var dismiss = false

    var id = UserDefaults.standard.object(forKey: ID) as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplate()
        fetchTemplateMemo()
        selectColor()
        setColor()
        bannerViewIsHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: EDIT_TEMP) != nil {
            baseViewIsHidden()
            if let row = UserDefaults.standard.object(forKey: SELECT_ROW) as? Int {
                let index = IndexPath(row: row, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
                UserDefaults.standard.removeObject(forKey: SELECT_ROW)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        memoTextField.becomeFirstResponder()
        baseView.isHidden = false
        viewHeight.constant = 50
        
        if templateMemos.count != 0 {
            let index = IndexPath(row: templateMemos.count, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
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
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }
        
        if let memoName = memoTextField.text {
            TemplateMemo.createTemplateMemo(name: memoName, id: id) { [self] in
                memoTextField.text = ""
                fetchTemplateMemo()
                let index = IndexPath(row: templateMemos.count, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    
    // MARK: - Fetch
    
    func fetchTemplateMemo() {
        
        TemplateMemo.fetchTemplateMemo(id: id) { [self] (templateMemo) in
            if templateMemo.count == 0 {
                tableView.isScrollEnabled = false
                noDataLabel.isHidden = false
                noDataLabel.text = "メモはありません\n左上のプラスボタンから作成できます"
            } else {
                tableView.isScrollEnabled = true
                noDataLabel.isHidden = true
            }
            templateMemos.removeAll()
            templateMemos.append(contentsOf: templateMemo)
            tableView.reloadData()
        }
    }
    
    func fetchTemplate() {
        Template.fetchTemplate(id: id) { [self] (template) in
            templateTextField.text = template.name
        }
    }
    
    // MARK: - Helpers
    
    func baseViewIsHidden() {
        baseView.isHidden = true
        viewHeight.constant = 0
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            viewBottomConst.constant = 0
            viewHeight.constant = 50
            bannerViewIsHidden()
        } else {
            if #available(iOS 11.0, *) {
                viewBottomConst.constant = view.safeAreaInsets.bottom - keyboardViewEndFrame.height
                if UserDefaults.standard.object(forKey: EDIT_TEMP) == nil {
                    baseView.isHidden = false
                    viewHeight.constant = 50
                    bannerViewIsHidden()
                }
            } else {
                viewBottomConst.constant = keyboardViewEndFrame.height
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc func textFieldBeginEditing() {
        UserDefaults.standard.set(true, forKey: EDIT_TEMP)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            baseViewIsHidden()
        }
    }
    
    func bannerViewIsHidden() {
        if defaults.object(forKey: PURCHASED) != nil {
            bannerHeight.constant = 0
            viewHeight.constant = 0
        } else {
            bannerHeight.constant = 84
            viewHeight.constant = 84
            switch UIScreen.main.nativeBounds.height {
            case 1334:
                bannerHeight.constant = 50
            case 2208:
                bannerHeight.constant = 50
            default:
                break
            }
        }
    }
    
    func setup() {
        navigationItem.title = "ひな形の編集"
        UserDefaults.standard.removeObject(forKey: EDIT_TEMP)

        createButton.layer.cornerRadius = 5
        closeButton.layer.cornerRadius = 5
        baseView.isHidden = true
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        templateTextField.delegate = self
        templateTextField.returnKeyType = .done
        templateTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        switch UIScreen.main.nativeBounds.height {
        case 1334:
            bannerHeight.constant = 50
        case 2208:
            bannerHeight.constant = 50
        default:
            break
        }
    }
    
    func setColor() {
        let placeholderColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .systemGray : .systemGray4
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        let bannerColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let labelColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        let labelColor2: UIColor = defaults.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
        let lineColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray5
        let memoViewColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK2_ALPHA)! : UIColor(named: O_WHITE)!
        let btnColor: UIColor = defaults.object(forKey: WHITE_COLOR) != nil || defaults.object(forKey: DARK_COLOR) != nil ? .systemBlue : .white

        deleteButton.tintColor = btnColor
        titleLabel.textColor = labelColor2
        memoLabel.textColor = labelColor
        tempNameLabel.textColor = labelColor
        bannerView.backgroundColor = bannerColor
        tableView.separatorColor = separatorColor
        tableView.backgroundColor = bannerColor
        memoListView.backgroundColor = memoViewColor
        topBaseView.backgroundColor = bannerColor
        topLineView.backgroundColor = lineColor
        bottomLineView.backgroundColor = lineColor
        templateTextField.textColor = labelColor
        templateTextField.backgroundColor = bannerColor
        templateTextField.attributedPlaceholder = NSAttributedString(string: "例）カレーライスの食材",attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            dismissButton.tintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            dismissButton.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_PINK)
            dismissButton.tintColor = UIColor.white
        } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_ORANGE_ALPHA)
            dismissButton.tintColor = UIColor.white
        } else {
            topView.backgroundColor = UIColor(named: O_DARK2_ALPHA)
            dismissButton.tintColor = UIColor.systemBlue
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

extension EditTemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateMemos.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateMemoTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! PlusBtnTableViewCell
        
        if indexPath.row == templateMemos.count {
            return cell2
        }
        cell.editTemplateVC = self
        cell.memoTextView.delegate = self
        cell.templateMemo = templateMemos[indexPath.row]
        cell.configureCell(templateMemos[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row != templateMemos.count {
            if editingStyle == .delete {
                TemplateMemo.deleteTemplateMemoUid(uid: templateMemos[indexPath.row].uid) { [self] in
                    templateMemos.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row != templateMemos.count {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row != destinationIndexPath.row else { return }

        let realm = try! Realm()
        let tempMemo = templateMemos[sourceIndexPath.row]
        let tempMemos = realm.objects(TemplateMemo.self)
            .filter("sourceRow == \(sourceIndexPath.row)").filter("templateId == '\(id)'")
        let tempMemos2 = realm.objects(TemplateMemo.self).filter("sorted == false").filter("templateId == '\(id)'")
        
        templateMemos.remove(at: sourceIndexPath.row)
        templateMemos.insert(tempMemo, at: destinationIndexPath.row)
        
        tempMemos.forEach { (t) in

            try! realm.write() {
                t.sourceRow = destinationIndexPath.row
                t.sorted = true
                
                tempMemos2.forEach { (t2) in

                    if t.sourceRow > t2.sourceRow {
                        if t.originRow < t2.sourceRow {
                            t2.sourceRow = t2.sourceRow - 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
                        }
                    } else if t.sourceRow < t2.sourceRow {
                        if t.originRow > t2.sourceRow {
                            t2.sourceRow = t2.sourceRow + 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
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
                        } else if t.originRow > t2.sourceRow {
                            t2.sourceRow = t2.sourceRow + 1
                            t2.originRow = t2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    t.originRow = t.sourceRow
                                }
                            }
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

extension EditTemplateViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
