//
//  TemplateListViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import RealmSwift
import AVFoundation
import GoogleMobileAds
import EmptyDataSet_Swift

class TemplateListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var seekBar: UISlider!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    @IBOutlet weak var videoWidth: NSLayoutConstraint!
    @IBOutlet weak var stackTopConst: NSLayoutConstraint!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var topLineView: UIView!
    
    private var allowMove = false
    private var dismiss = false
    private var templates = [Template]()
    private var id = ""
    private var videoPlayer: AVPlayer!
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        showHintView()
        setupBanner()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplates()
        selectColor()
        setColor()
        bannerViewIsHidden()
        defaults.removeObject(forKey: ID)
        defaults.removeObject(forKey: SETTING_VC)
        defaults.removeObject(forKey: "cart")

        if UserDefaults.standard.object(forKey: END_TUTORIAL2) == nil {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.object(forKey: END_TUTORIAL2) != nil {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = defaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    // MARK: - Actions
    
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
        }) { [self] (_) in
            self.visualEffectView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: END_TUTORIAL2)
        }
    }
    
    // MARK: - Helpers
    
    func bannerViewIsHidden() {
        let constant: CGFloat = defaults.object(forKey: PURCHASED) != nil ? 0 : 50
        bannerHeight.constant = constant
    }
    
    func showHintView() {
        
        if UserDefaults.standard.object(forKey: END_TUTORIAL2) == nil {
            setupVideoViewHeight()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
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
        
        guard let path = Bundle.main.path(forResource: "tutorial2", ofType: "mp4") else {
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
    
    func fetchTemplates() {
        
        Template.fetchTemplates { [self] (t) in
            templates.removeAll()
            templates.append(contentsOf: t)
            tableView.reloadData()
        }
    }
    
    func setupVideoViewHeight() {
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            videoHeight.constant = 380
            stackTopConst.constant = 10
        case 1792:
            videoHeight.constant = 530
            videoWidth.constant = 350
        case 2208:
            videoHeight.constant = 440
        case 2532:
            videoHeight.constant = 480
        case 2688:
            videoHeight.constant = 530
            videoWidth.constant = 350
        case 2778:
            videoHeight.constant = 560
            videoWidth.constant = 350
        default:
            break
        }
    }
    
    func setup() {
        hintView.alpha = 0
        startButton.layer.cornerRadius = 35 / 2
        skipButton.layer.cornerRadius = 35 / 2
        createButton.layer.cornerRadius = 35 / 2
        createButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOpacity = 0.3
        createButton.layer.shadowRadius = 4
        
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true

        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            topViewHeight.constant = 64
        case 2208:
            topViewHeight.constant = 64
        default:
            break
        }
    }
    
    func setColor() {
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        let bannerColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let lineColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray4
        let labelColor: UIColor = defaults.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
        
        createButton.tintColor = labelColor
        titleLabel.textColor = labelColor
        topLineView.backgroundColor = lineColor
        bannerView.backgroundColor = bannerColor
        tableView.separatorColor = separatorColor
        tableView.backgroundColor = bannerColor
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            createButton.backgroundColor = UIColor(named: EMERALD_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            createButton.backgroundColor = UIColor(named: O_WHITE)
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_PINK)
            createButton.backgroundColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
            topView.backgroundColor = UIColor(named: O_ORANGE_ALPHA)
            createButton.backgroundColor = UIColor(named: O_ORANGE)
        } else {
            topView.backgroundColor = UIColor(named: O_DARK2_ALPHA)
            createButton.backgroundColor = UIColor.systemBlue
        }
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func dragItem(for indexPath: IndexPath) -> UIDragItem {
        let tempName = templates[indexPath.row].name
        let itemProvider = NSItemProvider(object: tempName as NSString)
        
        return UIDragItem(itemProvider: itemProvider)
    }
    
    func moveItem(sourcePath: Int, destinationPath: Int) {
        let temps = templates.remove(at: sourcePath)
        templates.insert(temps, at: destinationPath)
    }
}

// MARK: - Table view

extension TemplateListViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    
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

extension TemplateListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TemplateListTableViewCell
        
        cell.templateListVC = self
        cell.template = templates[indexPath.row]
        cell.configureCell(templates[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        id = templates[indexPath.row].templateId
        UserDefaults.standard.set(id, forKey: ID)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let editTemplateVC = storyboard.instantiateViewController(withIdentifier: "EditTemplateVC")
        editTemplateVC.presentationController?.delegate = self
        self.present(editTemplateVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            TemplateMemo.deleteTempMemo(id: templates[indexPath.row].templateId) { [self] in
                templates.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.row != destinationIndexPath.row else { return }

        let realm = try! Realm()
        let temp = templates[sourceIndexPath.row]
        let temps = realm.objects(Template.self).filter("sourceRow == \(sourceIndexPath.row)")
        templates.remove(at: sourceIndexPath.row)
        templates.insert(temp, at: destinationIndexPath.row)
        
        temps.forEach { (t) in

            try! realm.write() {
                t.sourceRow = destinationIndexPath.row
                t.sorted = true
                let tempMemos2 = realm.objects(Template.self).filter("sorted == false")
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

extension TemplateListViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "ひな形はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "画面下の'ひな形を作成する'から作成できます", attributes: attributes)
    }
}

extension TemplateListViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

extension TemplateListViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    fetchTemplates()
    setNeedsStatusBarAppearanceUpdate()
    dispatchQ.asyncAfter(deadline: .now() + 0.6) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
  }
}
