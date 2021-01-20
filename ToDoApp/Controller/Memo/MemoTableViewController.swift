//
//  MemoTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/25.
//

import UIKit
import GoogleMobileAds
import RealmSwift
import AVFoundation
import SwiftEntryKit
import WatchConnectivity
import StoreKit
import PKHUD

class MemoTableViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var templateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoWidth: NSLayoutConstraint!
    @IBOutlet weak var stackTopConst: NSLayoutConstraint!
    @IBOutlet weak var templateButton: UIButton!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var sortWidth: NSLayoutConstraint!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var titleBottomConst: NSLayoutConstraint!
    @IBOutlet weak var deleteBtnBottomConst: NSLayoutConstraint!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topLineView2: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    var session = WCSession.default
    var watchData = ""
    var allowMove = false
    var forbidden = false
    var panGesture = false
    var onSort = false
    var date = Date()
    let calendar = Calendar.current
    var memoArray = [Memo]()
    var videoPlayer: AVPlayer!
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var templateId = ""
    var player = AVAudioPlayer()
    let soundFile = Bundle.main.path(forResource: "button01", ofType: "mp3")
    var panInitialLocation: CGFloat!
    lazy var topViews = [topView,topView,topView,topView,topView,topView,topView,topView,topView,topView,]
    var scrollBeginPoint: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        reWrite()
        setupSound()
        showHintView()
        setupBanner()
        setNeedsStatusBarAppearanceUpdate()
        
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.removeObject(forKey: SETTING_VC)
        
        navigationController?.navigationBar.isHidden = true
        if defaults.object(forKey: ON_PUSH) != nil {
            checkTempMemoHistory()
        }
        if defaults.object(forKey: "cart") == nil {
            templateButton.setTitle("ひな形に登録", for: .normal)
        }
        fetchMemo()
        setColor()
        selectColor()
        fetchTemplateTitle()
        setBackAction()
        setupKeyboard()
        showRequestReview()
        fetchSelectedItemName()
        bannerViewIsHidden()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if defaults.object(forKey: EDIT_MEMO) != nil {
            baseViewIsHidden()
            if let row = defaults.object(forKey: SELECT_ROW) as? Int {
                let index = IndexPath(row: row, section: 0)
                tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
                defaults.removeObject(forKey: SELECT_ROW)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = defaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    // MARK: - Actions
    
    @IBAction func cartButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let historyVC = storyboard.instantiateViewController(withIdentifier: "HistoryVC")
        historyVC.presentationController?.delegate = self
        self.present(historyVC, animated: true, completion: nil)
    }
    
    @IBAction func tempBtnPanGesture(_ sender: UIPanGestureRecognizer) {
        let move: CGPoint = sender.translation(in: self.view)
        sender.view!.center.y += move.y
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        switch sender.state {
        case .began:
            if panInitialLocation == nil {
                panInitialLocation = sender.view!.center.y
            }
        case .changed:
            if sender.view!.center.y < panInitialLocation {
                sender.view!.center.y = panInitialLocation
            } else if sender.view!.center.y > panInitialLocation + 55 {
                tempBtnDownAnimation2()
            }
        case .ended:
            if sender.view!.center.y < panInitialLocation + 56 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: { [self] in
                    sender.view!.center.y = panInitialLocation
                }, completion: nil)
            } else {
                tempBtnDownAnimation2()
            }
        default:
            break
        }
    }
    
    @IBAction func tapTemplabel(_ sender: Any) {
        dispatchQ.async {
            UIView.animate(withDuration: 0.3) { [self] in
                topView.isHidden = true
                dispatchQ.asyncAfter(deadline: .now() + 0.2) {
                    if topView.isHidden {
                        topLineView2.isHidden = false
                    }
                }
            }
        }
    }
    
    @IBAction func tapStatusView(_ sender: Any) {
        dispatchQ.async {
            UIView.animate(withDuration: 0.3) { [self] in
                topViews.forEach({$0?.isHidden = false})
                topLineView2.isHidden = true
            }
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        
        memoTextField.becomeFirstResponder()
        baseView.isHidden = false
        viewHeight.constant = 50
        
        if memoArray.count != 0 {
            let index = IndexPath(row: memoArray.count, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
        
        if defaults.object(forKey: ON_INPUT) != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "ItemListVC", sender: nil)
            }
        }
    }
    
    @IBAction func templateButtonTapped(_ sender: Any) {
        if defaults.object(forKey: "cart") != nil {
            defaults.set(templateId, forKey: ID)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let tempHVC = storyboard.instantiateViewController(withIdentifier: "TempHVC")
            tempHVC.presentationController?.delegate = self
            self.present(tempHVC, animated: true, completion: nil)
        } else {
            let id = UUID().uuidString
            let dateformater = DateFormatter()
            dateformater.dateFormat = "yyyy年M月d日"
            dateformater.locale = Locale(identifier: "ja_JP")
            let tempName = "メモ: " + dateformater.string(from: Date())
            
            Memo.fetchMemo(sort: onSort) { (memos) in
                Template.createTemplate(text: tempName, id: id) {}
                memos.forEach { (m) in
                    TemplateMemo.createMemoToTemplateMemo(name: m.name, uid: m.uid, date: m.date, id: id) {
                        HUD.flash(.labeledSuccess(title: "", subtitle: "登録しました"), delay: 1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            UIView.animate(withDuration: 0.5) { [self] in
                                tempBtnDownAnimation()
                                panGesture = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func onSlider(_ sender: UISlider) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(Float64(seekBar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 0
            self.hintView.alpha = 0
        }) { (_) in
            self.visualEffectView.removeFromSuperview()
            defaults.set(true, forKey: END_TUTORIAL1)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        memoTextField.resignFirstResponder()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "すべて削除してよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            Template.fetchTemplates { _ in
                fetchTemplateTitle()
            }
            Memo.deleteMemos {
                memoArray.removeAll()
                tableView.reloadData()
                memoTextField.resignFirstResponder()
                fetchMemo()
                dispatchQ.async {
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { (_) in
            dispatchQ.async {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        
        Memo.checkMemosCount { [self] (bool) in
            if bool {
                memoTextField.resignFirstResponder()
                alert.addAction(delete)
                alert.addAction(cancel)
                self.present(alert, animated: true)
            }
        }
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        if onSort {
            onSort = false
            fetchMemo()
            sortButton.setImage(UIImage(named: "sort_off"), for: .normal)
            
            let color: UIColor = defaults.object(forKey: GREEN_COLOR) != nil ? .systemGray4 : .systemGray
            sortButton.tintColor = color
        } else {
            onSort = true
            fetchMemo()
            sortButton.setImage(UIImage(named: "sort_on"), for: .normal)
            
            if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
                sortButton.tintColor = UIColor.white
            } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
                sortButton.tintColor = UIColor.systemBlue
            } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
                sortButton.tintColor = UIColor.white
            } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
                sortButton.tintColor = UIColor.white
            } else {
                sortButton.tintColor = UIColor.systemBlue
            }
        }
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
        guard memoTextField.text != "" else { return }
        
        Memo.createMemo(text: memoTextField.text!) { [self] in
            memoTextField.text = ""
            panGesture = false
            fetchMemo()
            let index = IndexPath(row: memoArray.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    // MARK: - Fetch
    
    func fetchMemo() {
        Memo.fetchMemo(sort: onSort) { [self] (memos) in
            if memos.count == 0 {
                noDataLabel.isHidden = false
                noDataLabel.text = "メモはありません\n左上のプラスボタンから作成できます"
                tableView.isScrollEnabled = false
            } else {
                noDataLabel.isHidden = true
                tableView.isScrollEnabled = true
            }
            
            memoArray.removeAll()
            memoArray.append(contentsOf: memos)
            dispatchQ.async {
                tableView.reloadData()
            }
            
            if defaults.object(forKey: PAN) != nil {
                panGesture = false
                defaults.removeObject(forKey: PAN)
            }
            
            if memoArray.count >= 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.5) {
                        if !panGesture {
                            templateButton.setTitle("ひな形に登録", for: .normal)
                            defaults.removeObject(forKey: "cart")
                            tempBtnUpAnimation()
                        }
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.5) {
                        tempBtnDownAnimation()
                    }
                }
            }
            wcSessionUpdate()
            createTempToMemo()
        }
    }
    
    func createTempToMemo() {
        
        Memo.createTemplateToMemo { [self] (memo) in
            if memo.count != 0 {
                noDataLabel.isHidden = true
                tableView.isScrollEnabled = true
            }
            fetchTemplateTitle()
            panGesture = true
            tempBtnDownAnimation()
            memoArray = memo
            memoArray = memoArray.sorted(by: { (a, b) -> Bool in
                return a.sourceRow < b.sourceRow
            })
            dispatchQ.async {
                tableView.reloadData()
            }
            wcSessionUpdate()
        }
    }
    
    func wcSessionUpdate() {
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
    
    func fetchTemplateTitle() {
        
        Template.fetchSelectedTemplate { [self] (bool, template) in
            if bool {
                topViewHeight.constant = 120
                titleBottomConst.constant = 15
                deleteBtnBottomConst.constant = 35
                templateLabel.isHidden = false
                templateLabel.text = "\(template.name)を選択中"
                let color: UIColor = defaults.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
                templateLabel.textColor = color
                templateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                switch (UIScreen.main.nativeBounds.height) {
                case 1334:
                    topViewHeight.constant = 100
                case 2208:
                    topViewHeight.constant = 100
                default:
                    break
                }
            } else {
                topViewHeight.constant = 100
                titleBottomConst.constant = -5
                deleteBtnBottomConst.constant = 10
                templateLabel.isHidden = true
                switch (UIScreen.main.nativeBounds.height) {
                case 1334:
                    topViewHeight.constant = 80
                case 2208:
                    topViewHeight.constant = 80
                default:
                    break
                }
            }
        }
    }
    
    func fetchSelectedItemName() {
        Memo.selectedItemName { [self] (bool) in
            fetchMemo()
            panGesture = bool
        }
    }
    
    func checkTempMemoHistory() {
        
        let realm = try! Realm()
        let templates = realm.objects(Template.self).filter("isSelect == true")
        
        if templates.count == 1 {
            templates.forEach { (t) in
                
                let tempMemos = realm.objects(TemplateMemo.self)
                    .filter("templateId == '\(t.templateId)'").filter("date > 0")
                if tempMemos.count > 0 {
                    templateId = t.templateId
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                        player.play()
                        player.numberOfLoops = 1
                        historyPopup()
                    }
                }
            }
        }
    }
}

// MARK: - Table view

extension MemoTableViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.row == memoArray.count {
            forbidden = true
            return []
        }
        forbidden = false
        return [dragItem(for: indexPath)]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).sorted(byKeyPath: "sourceRow", ascending: true)
        
        if forbidden {
            return UITableViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
        
        memos.forEach { (m) in
            let allow = destinationIndexPath?.row == nil || destinationIndexPath!.row >= m.sourceRow + 1 ? false : true
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

extension MemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MemoTableViewCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! PlusBtnTableViewCell
        
        if indexPath.row == memoArray.count {
            return cell2
        }
        cell.session.delegate = self
        cell.watchData = self.watchData
        cell.memoVC = self
        cell.memoTextView.delegate = self
        cell.memo = memoArray[indexPath.row]
        cell.configureCell(memoArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            Memo.deleteMemo(id: memoArray[indexPath.row].uid) { [self] in
                memoArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                dispatchQ.async {
                    tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row != memoArray.count {
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
        let memos = realm.objects(Memo.self).filter("sourceRow == %@", sourceIndexPath.row)
        let memos2 = realm.objects(Memo.self).filter("sorted == false")
        let memo = memoArray[sourceIndexPath.row]
        
        memoArray.remove(at: sourceIndexPath.row)
        memoArray.insert(memo, at: destinationIndexPath.row)
        
        print("-------start-------")
        
        memos.forEach { (m) in
            
            try! realm.write() {
                m.sourceRow = destinationIndexPath.row
                m.sorted = true
                memos2.forEach { (m2) in
                    
                    if m.sourceRow > m2.sourceRow {
                        if m.originRow < m2.sourceRow {
                            m2.sourceRow = m2.sourceRow - 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("minus: ", m2.name)
                        } else {
                            print("stay1: ", m2.name)
                        }
                        
                    } else if m.sourceRow < m2.sourceRow {
                        if m.originRow > m2.sourceRow {
                            m2.sourceRow = m2.sourceRow + 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("plus: ", m2.name)
                        } else {
                            print("stay2: ", m2.name)
                        }
                    } else if m.sourceRow == m2.sourceRow {
                        if m.originRow < m2.sourceRow {
                            m2.sourceRow = m2.sourceRow - 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("== minus: ", m2.name)
                        } else if m.originRow > m2.sourceRow {
                            m2.sourceRow = m2.sourceRow + 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("== plus: ", m2.name)
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        try! realm.write() {
                            m.sorted = false
                        }
                    }
                }
            }
        }
        wcSessionUpdate()
    }
}

// MARK: - WCSessionDelegate

extension MemoTableViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        if let tableData = applicationContext["WatchTableData"] as? String {
            DispatchQueue.main.async { [self] in
                defaults.removeObject(forKey: RELOAD)
                self.watchData = tableData
                self.tableView.reloadData()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
}

extension MemoTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

extension MemoTableViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        setNeedsStatusBarAppearanceUpdate()
        fetchSelectedItemName()
        dispatchQ.asyncAfter(deadline: .now() + 0.7) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        if defaults.object(forKey: "cart") != nil {
            dispatchQ.async { [self] in
                templateButton.setTitle("カート履歴", for: .normal)
                tempBtnUpAnimation()
            }
        }
    }
}
