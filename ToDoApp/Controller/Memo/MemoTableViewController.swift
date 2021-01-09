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
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var sortWidth: NSLayoutConstraint!
    
    private var session = WCSession.default
    private var watchData = ""
    private var allowMove = false
    private var forbidden = false
    private var panGesture = false
    private var on_sort = false
    private var date = Date()
    private let calendar = Calendar.current
    private var memoArray = [Memo]()
    private var videoPlayer: AVPlayer!
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    private var templateId = ""
    private var player = AVAudioPlayer()
    private let soundFile = Bundle.main.path(forResource: "button01", ofType: "mp3")
    private var panInitialLocation: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupSound()
        showHintView()
        setupBanner()
        print(Realm.Configuration.defaultConfiguration.fileURL as Any)
        
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        if UserDefaults.standard.object(forKey: ON_PUSH) != nil {
            checkTempMemoHistory()
        }
        fetchMemo()
        setColor()
        selectColor()
        fetchTemplate()
        setBackAction()
        showRequestReview()
        fetchSelectedItemName()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: EDIT_MEMO) != nil {
            baseViewIsHidden()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
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
            } else if sender.view!.center.y > panInitialLocation + 50 {
                tempBtnDownAnimation2()
            }
        case .ended:
            if sender.view!.center.y < panInitialLocation + 50 {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: { [self] in
                    sender.view!.center.y = panInitialLocation
                }, completion: nil)
            }
         default:
            break
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        
        baseView.isHidden = false
        memoTextField.becomeFirstResponder()
            
        if memoArray.count != 0 {
            let index = IndexPath(row: memoArray.count - 1, section: 0)
            tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.bottom, animated: true)
        }
            
        if UserDefaults.standard.object(forKey: ON_INPUT) != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "ItemListVC", sender: nil)
            }
        }
    }
    
    @IBAction func templateButtonTapped(_ sender: Any) {
        
        let id = UUID().uuidString
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy年M月d日"
        dateformater.locale = Locale(identifier: "ja_JP")
        let tempName = "メモ: " + dateformater.string(from: Date())
        
        Memo.fetchMemo(sort: on_sort) { (memos) in
            Template.createTemplate(text: tempName, id: id) {}
            memos.forEach { (m) in
                TemplateMemo.createTemplateMemo(text: m.name, id: id) {
                    HUD.flash(.labeledSuccess(title: "", subtitle: "登録しました"), delay: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        UIView.animate(withDuration: 0.5) { [self] in
                            tempBtnDownAnimation()
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
            UserDefaults.standard.set(true, forKey: END_TUTORIAL1)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        memoTextField.resignFirstResponder()
        fetchMemo()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "すべて削除してよろしいですか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除する", style: UIAlertAction.Style.default) { [self] (alert) in
            
            Template.updateSelected { _ in
                fetchTemplate()
            }
            Memo.deleteMemos {
                memoArray.removeAll()
                tableView.reloadData()
                memoTextField.resignFirstResponder()
                fetchMemo()
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
        if on_sort {
            on_sort = false
            fetchMemo()
            sortButton.setImage(UIImage(named: "sort_off"), for: .normal)
            let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .systemGray4 : .systemGray
            sortButton.tintColor = color
        } else {
            on_sort = true
            fetchMemo()
            sortButton.setImage(UIImage(named: "sort_on"), for: .normal)
            let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .white : UIColor(named: EMERALD_GREEN)!
            sortButton.tintColor = color
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
        
        Memo.fetchMemo(sort: on_sort) { [self] (memos) in
            memoArray.removeAll()
            memoArray.append(contentsOf: memos)
            tableView.reloadData()
            if UserDefaults.standard.object(forKey: PAN) != nil {
                panGesture = false
                UserDefaults.standard.removeObject(forKey: PAN)
            }
            if memoArray.count >= 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    UIView.animate(withDuration: 0.5) {
                        if !panGesture {
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
            
            var tableData = [String]()
            memoArray.forEach { (m) in
                tableData.append(m.name)
            }
            
            guard WCSession.isSupported() else { return }
            do{
                try WCSession.default.updateApplicationContext(["WatchTableData" : tableData])
            }
            catch {
                print(error.localizedDescription)
            }
            createTempToMemo()
        }
    }
    
    func createTempToMemo() {
        
        Memo.createTemplateToMemo { [self] (memo) in
            fetchTemplate()
            panGesture = true
            tempBtnDownAnimation()
            memoArray = memo
            memoArray = memoArray.sorted(by: { (a, b) -> Bool in
                return a.sourceRow < b.sourceRow
            })
            tableView.reloadData()

            var tableData = [String]()
            memoArray.forEach { (m) in
                tableData.append(m.name)
            }
            
            guard WCSession.isSupported() else { return }
            do{
                try WCSession.default.updateApplicationContext(["WatchTableData" : tableData])
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTemplate() {
        
        Template.fetchSelectedTemplate { [self] (bool, template) in
            if bool == true {
                templateLabel.text = "\(template.name)を選択中"
                let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
                templateLabel.textColor = color
            } else {
                templateLabel.text = "ひな形未選択"
                let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .systemGray5 : .systemGray
                templateLabel.textColor = color
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
    
    // MARK: - Helpers
    
    func showRequestReview() {
        if let threeWeek = UserDefaults.standard.object(forKey: REVIEW) as? Date {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                if date >= threeWeek {
                    SKStoreReviewController.requestReview()
                    let newThreeWeek = calendar.date(byAdding: .day, value: 21, to: date)
                    UserDefaults.standard.set(newThreeWeek, forKey: REVIEW)
                } else {
                    print(threeWeek)
                }
            }
        }
    }
    
    func historyPopup() {
        
        var attributes = EKAttributes.bottomFloat
        attributes.displayDuration = .infinity
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor(UIColor(named: FOREST_GREEN)!), EKColor(UIColor(named: EMERALD_GREEN)!)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .visualEffect(style: .prominent)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.width), height: .intrinsic)
        attributes.entryInteraction = .absorbTouches
        let title = EKProperty.LabelContent(text: "前回のカート履歴", style: .init(font: UIFont(name: "HiraMaruProN-W4", size: 20)!, color: .white))
        let description = EKProperty.LabelContent(text: "履歴を確認しますか？", style: .init(font: UIFont(name: "HiraMaruProN-W4", size: 15)!, color: .white))
        
        let label = EKProperty.LabelContent(text: "確認する", style: .init(font: UIFont(name: "HiraMaruProN-W4", size: 15)!, color: EKColor(UIColor(named: O_BLACK)!)))
        let button = EKProperty.ButtonContent(label: label, backgroundColor: .white, highlightedBackgroundColor: .standardBackground)
        let action: EKPopUpMessage.EKPopUpMessageAction = {
            SwiftEntryKit.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performSegue(withIdentifier: "TempMemoHistoryVC", sender: nil)
            }
        }
        let popupMessage = EKPopUpMessage(title: title, description: description, button: button, action: action)
        let view = EKPopUpMessageView(with: popupMessage)
        
        SwiftEntryKit.display(entry: view, using: attributes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TempMemoHistoryVC" {
            let tempMemoHistoryVC = segue.destination as! TempMemoHistoryTableViewController
            tempMemoHistoryVC.templateId = templateId
        }
    }
    
    func setupSound() {
        do {
            try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: soundFile!))
            player.prepareToPlay()
        } catch  {
            print("Error sound", error.localizedDescription)
        }
    }
    
    func showHintView() {
        
        if UserDefaults.standard.object(forKey: END_TUTORIAL1) == nil {
            setupVideoViewHeight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                visualEffectView.frame = self.view.frame
                visualEffectView.alpha = 0
                view.addSubview(self.visualEffectView)
                view.addSubview(hintView)
                setVideoPlayer()
                
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    visualEffectView.alpha = 1
                    hintView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    func setVideoPlayer() {
        
        guard let path = Bundle.main.path(forResource: "tutorial1", ofType: "mp4") else {
            fatalError("Movie file can not find.")
        }
        let fileURL = URL(fileURLWithPath: path)
        let avAsset = AVURLAsset(url: fileURL)
        let playerItem: AVPlayerItem = AVPlayerItem(asset: avAsset)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let layer = AVPlayerLayer()
        layer.videoGravity = AVLayerVideoGravity.resizeAspect
        layer.player = videoPlayer
        layer.frame = videoView.bounds
        videoView.layer.addSublayer(layer)
        
        seekBar.minimumValue = 0
        seekBar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        
        let interval : Double = Double(0.5 * seekBar.maximumValue) / Double(seekBar.bounds.maxX)
        
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        
        videoPlayer.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            
            let duration = CMTimeGetSeconds(self.videoPlayer.currentItem!.duration)
            let time = CMTimeGetSeconds(self.videoPlayer.currentTime())
            let value = Float(self.seekBar.maximumValue - self.seekBar.minimumValue) * Float(time) / Float(duration) + Float(self.seekBar.minimumValue)
            self.seekBar.value = value
        })
        videoPlayer.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: Int32(NSEC_PER_SEC)))
        videoPlayer.play()
    }
    
    func setupVideoViewHeight() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            videoHeight.constant = 400
            stackTopConst.constant = 10
        case 1792:
            videoHeight.constant = 530
            videoWidth.constant = 350
        case 2532:
            videoHeight.constant = 500
        case 2688:
            videoHeight.constant = 550
            videoWidth.constant = 350
        case 2778:
            videoHeight.constant = 580
            videoWidth.constant = 350
        default:
            break
        }
    }
    
    func baseViewIsHidden() {
        if UserDefaults.standard.object(forKey: EDIT_MEMO) != nil {
            baseView.isHidden = true
            viewHeight.constant = 0
        } else {
            baseView.isHidden = false
            viewHeight.constant = 50
        }
    }
    
    func setBackAction() {
        if UserDefaults.standard.object(forKey: BACK) != nil {
            memoTextField.resignFirstResponder()
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
    
    func tempBtnUpAnimation() {
        UIView.animate(withDuration: 1) { [self] in
            templateButton.transform = .identity
        }
    }
    
    func tempBtnDownAnimation() {
        UIView.animate(withDuration: 1) { [self] in
            templateButton.transform = CGAffineTransform(translationX: 0, y: 150)
        }
    }
    
    func tempBtnDownAnimation2() {
        UIView.animate(withDuration: 0.3) { [self] in
            panGesture = true
            templateButton.transform = CGAffineTransform(translationX: 0, y: 150)
        }
    }
    
    func setup() {
        navigationItem.title = "買い物メモ"
        UserDefaults.standard.removeObject(forKey: EDIT_MEMO)
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        hintView.alpha = 0
        baseView.isHidden = true
        closeButton.layer.cornerRadius = 5
        createButton.layer.cornerRadius = 5
        startButton.layer.cornerRadius = 35 / 2
        skipButton.layer.cornerRadius = 35 / 2
        templateButton.layer.cornerRadius = 35 / 2
        templateButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        templateButton.layer.shadowColor = UIColor.black.cgColor
        templateButton.layer.shadowOpacity = 0.3
        templateButton.layer.shadowRadius = 4
        templateButton.transform = CGAffineTransform(translationX: 0, y: 150)
        templateLabel.text = "ひな形未選択"
        viewHeight.constant = 0
        memoTextField.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            topViewHeight.constant = 80
        case 2208:
            topViewHeight.constant = 80
        default:
            break
        }
    }
    
    func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            deleteButton.tintColor = UIColor.white
            templateLabel.textColor = UIColor.systemGray5
            historyButton.tintColor = UIColor.white
            templateButton.backgroundColor = UIColor(named: EMERALD_GREEN)
            templateButton.tintColor = UIColor.white
            let color = on_sort ? UIColor.white : UIColor.systemGray4
            sortButton.tintColor = color

        } else {
            titleLabel.textColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            deleteButton.tintColor = UIColor(named: EMERALD_GREEN)
            templateLabel.textColor = UIColor.systemGray
            historyButton.tintColor = UIColor(named: EMERALD_GREEN)
            templateButton.backgroundColor = UIColor(named: O_WHITE)
            templateButton.tintColor = UIColor(named: O_BLACK)
            let color = on_sort ? UIColor(named: EMERALD_GREEN)! : UIColor.systemGray
            sortButton.tintColor = color
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        memoTextField.resignFirstResponder()
        fetchMemo()
        return true
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let memoName = memoArray[indexPath.row].name
        let itemProvider = NSItemProvider(object: memoName as NSString)

        return UIDragItem(itemProvider: itemProvider)
    }
    
    func moveItem(sourcePath: Int, destinationPath: Int) {
        let memos = memoArray.remove(at: sourcePath)
        memoArray.insert(memos, at: destinationPath)
    }
}

// MARK: - Table view

extension MemoTableViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row != memoArray.count else {
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
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        
        if indexPath.row == memoArray.count {
            return cell2!
        }
        
        cell.watchData = self.watchData
        cell.memoVC = self
        cell.memoTextView.delegate = self
        cell.memo = memoArray[indexPath.row]
        cell.configureCell(memoArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
        let realm = try! Realm()
        let memos = realm.objects(Memo.self).filter("sourceRow == \(sourceIndexPath.row)")
        let memo = memoArray[sourceIndexPath.row]
        memoArray.remove(at: sourceIndexPath.row)
        memoArray.insert(memo, at: destinationIndexPath.row)
        
        if sourceIndexPath.row == destinationIndexPath.row { return }
        
        print("-------start-------")
        
        memos.forEach { (m) in
            
            try! realm.write() {
                m.sourceRow = destinationIndexPath.row
                m.sorted = true
                let memos2 = realm.objects(Memo.self).filter("sorted == false")
                memos2.forEach { (m2) in
                    
                    if m.sourceRow > m2.sourceRow {
                        if m.originRow > m2.sourceRow {
                            print("stay1: ", m2.name)
                        } else {
                            m2.sourceRow = m2.sourceRow - 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("minus: ", m2.name)
                        }
                        
                    } else if m.sourceRow < m2.sourceRow {
                        if m.originRow < m2.sourceRow {
                            print("stay2: ", m2.name)
                        } else {
                            m2.sourceRow = m2.sourceRow + 1
                            m2.originRow = m2.sourceRow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                try! realm.write() {
                                    m.originRow = m.sourceRow
                                }
                            }
                            print("plus: ", m2.name)
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
    }
}

// MARK: - WCSessionDelegate

extension MemoTableViewController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        if let tableData = applicationContext["WatchTableData"] as? String {
            DispatchQueue.main.async {
                UserDefaults.standard.removeObject(forKey: RELOAD)
                self.watchData = tableData
                self.tableView.reloadData()
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
}
