//
//  MemoVC+Helpers.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/19.
//

import GoogleMobileAds
import RealmSwift
import AVFoundation
import SwiftEntryKit
import WatchConnectivity
import StoreKit
import PKHUD

extension MemoTableViewController {
    
    // MARK: - Helpers
    
    func reWrite() {
        let realm = try! Realm()
        let histories = realm.objects(History.self)
        histories.forEach { (h) in
            try! realm.write() {
                if h.timestamp == "2021年1月9日 (土)" {
                    h.timestamp = "2021年01月09日 (土)"
                } else if h.timestamp == "2021年1月10日 (日)" {
                    h.timestamp = "2021年01月10日 (日)"
                } else if h.timestamp == "2021年1月11日 (月)" {
                    h.timestamp = "2021年01月11日 (月)"
                } else if h.timestamp == "2021年1月12日 (火)" {
                    h.timestamp = "2021年01月12日 (火)"
                } else if h.timestamp == "2021年1月13日 (水)" {
                    h.timestamp = "2021年01月13日 (水)"
                } else if h.timestamp == "2021年1月14日 (木)" {
                    h.timestamp = "2021年01月14日 (木)"
                } else if h.timestamp == "2021年1月15日 (金)" {
                    h.timestamp = "2021年01月15日 (金)"
                } else if h.timestamp == "2021年1月16日 (土)" {
                    h.timestamp = "2021年01月16日 (土)"
                } else if h.timestamp == "2021年1月17日 (日)" {
                    h.timestamp = "2021年01月17日 (日)"
                } else if h.timestamp == "2021年1月18日 (月)" {
                    h.timestamp = "2021年01月18日 (月)"
                } else if h.timestamp == "2021年1月19日 (火)" {
                    h.timestamp = "2021年01月19日 (火)"
                } else if h.timestamp == "2021年1月20日 (水)" {
                    h.timestamp = "2021年01月20日 (水)"
                } else if h.timestamp == "2021年1月21日 (木)" {
                    h.timestamp = "2021年01月21日 (木)"
                } else if h.timestamp == "2021年1月22日 (金)" {
                    h.timestamp = "2021年01月22日 (金)"
                } else if h.timestamp == "2021年1月23日 (土)" {
                    h.timestamp = "2021年01月23日 (土)"
                } else if h.timestamp == "2021年1月24日 (日)" {
                    h.timestamp = "2021年01月24日 (日)"
                } else if h.timestamp == "2021年1月25日 (月)" {
                    h.timestamp = "2021年01月25日 (月)"
                } else if h.timestamp == "2021年1月26日 (火)" {
                    h.timestamp = "2021年01月26日 (火)"
                } else if h.timestamp == "2021年1月27日 (水)" {
                    h.timestamp = "2021年01月27日 (水)"
                } else if h.timestamp == "2021年1月28日 (木)" {
                    h.timestamp = "2021年01月28日 (木)"
                } else if h.timestamp == "2021年1月29日 (金)" {
                    h.timestamp = "2021年01月29日 (金)"
                } else if h.timestamp == "2021年1月30日 (土)" {
                    h.timestamp = "2021年01月30日 (土)"
                } else if h.timestamp == "2021年1月31日 (日)" {
                    h.timestamp = "2021年01月31日 (日)"
                } else if h.timestamp == "2021年2月1日 (月)" {
                    h.timestamp = "2021年02月01日 (月)"
                } else if h.timestamp == "2021年2月2日 (火)" {
                    h.timestamp = "2021年02月02日 (火)"
                } else if h.timestamp == "2021年2月3日 (水)" {
                    h.timestamp = "2021年02月03日 (水)"
                } else if h.timestamp == "2021年2月4日 (木)" {
                    h.timestamp = "2021年02月04日 (木)"
                } else if h.timestamp == "2021年2月5日 (金)" {
                    h.timestamp = "2021年02月05日 (金)"
                } else if h.timestamp == "2021年2月6日 (土)" {
                    h.timestamp = "2021年02月06日 (土)"
                } else if h.timestamp == "2021年2月7日 (日)" {
                    h.timestamp = "2021年02月07日 (日)"
                } else if h.timestamp == "2021年2月8日 (月)" {
                    h.timestamp = "2021年02月08日 (月)"
                } else if h.timestamp == "2021年2月9日 (火)" {
                    h.timestamp = "2021年02月09日 (火)"
                } else if h.timestamp == "2021年2月10日 (水)" {
                    h.timestamp = "2021年02月10日 (水)"
                } else if h.timestamp == "2021年2月11日 (木)" {
                    h.timestamp = "2021年02月11日 (木)"
                } else if h.timestamp == "2021年2月12日 (金)" {
                    h.timestamp = "2021年02月12日 (金)"
                } else if h.timestamp == "2021年2月13日 (土)" {
                    h.timestamp = "2021年02月13日 (土)"
                } else if h.timestamp == "2021年2月14日 (日)" {
                    h.timestamp = "2021年02月14日 (日)"
                } else if h.timestamp == "2021年2月15日 (月)" {
                    h.timestamp = "2021年02月15日 (月)"
                } else if h.timestamp == "2021年2月16日 (火)" {
                    h.timestamp = "2021年02月16日 (火)"
                } else if h.timestamp == "2021年2月17日 (水)" {
                    h.timestamp = "2021年02月17日 (水)"
                } else if h.timestamp == "2021年2月18日 (木)" {
                    h.timestamp = "2021年02月18日 (木)"
                } else if h.timestamp == "2021年2月19日 (金)" {
                    h.timestamp = "2021年02月19日 (金)"
                } else if h.timestamp == "2021年2月20日 (土)" {
                    h.timestamp = "2021年02月20日 (土)"
                } else if h.timestamp == "2021年2月21日 (日)" {
                    h.timestamp = "2021年02月21日 (日)"
                } else if h.timestamp == "2021年2月22日 (月)" {
                    h.timestamp = "2021年02月22日 (月)"
                } else if h.timestamp == "2021年2月23日 (火)" {
                    h.timestamp = "2021年02月23日 (火)"
                } else if h.timestamp == "2021年2月24日 (水)" {
                    h.timestamp = "2021年02月24日 (水)"
                } else if h.timestamp == "2021年2月25日 (木)" {
                    h.timestamp = "2021年02月25日 (木)"
                } else if h.timestamp == "2021年2月26日 (金)" {
                    h.timestamp = "2021年02月26日 (金)"
                } else if h.timestamp == "2021年2月27日 (土)" {
                    h.timestamp = "2021年02月27日 (土)"
                } else if h.timestamp == "2021年2月28日 (日)" {
                    h.timestamp = "2021年02月28日 (日)"
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginPoint = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollBeginPoint - scrollView.contentOffset.y
        let topViewScrollY: CGFloat = scrollView.contentOffset.y - 150
        
        if topViewScrollY != -200 {
            if topViewScrollY > -20 {
                dispatchQ.async { [self] in
                    statusView.isHidden = false
                    UIView.animate(withDuration: 0.3) { [self] in
                        topView.isHidden = true
                        dispatchQ.asyncAfter(deadline: .now() + 0.2) {
                            if topView.isHidden {
                                topLineView2.isHidden = false
                            }
                        }
                    }
                }
            } else if scrollDiff >= 50 {
                dispatchQ.async { [self] in
                    UIView.animate(withDuration: 0.3) { [self] in
                        topViews.forEach({$0?.isHidden = false})
                        topLineView2.isHidden = true
                        UIView.animate(withDuration: 0.3) { [self] in
                            statusView.isHidden = true
                        }
                    }
                }
            }
        }
    }
    
    func tempBtnUpAnimation() {
        dispatchQ.async {
            UIView.animate(withDuration: 1) { [self] in
                templateButton.transform = .identity
            }
        }
    }
    
    func tempBtnDownAnimation() {
        dispatchQ.async {
            UIView.animate(withDuration: 1) { [self] in
                templateButton.transform = CGAffineTransform(translationX: 0, y: 200)
            }
        }
    }
    
    func tempBtnDownAnimation2() {
        dispatchQ.async {
            UIView.animate(withDuration: 0.3) { [self] in
                panGesture = true
                templateButton.transform = CGAffineTransform(translationX: 0, y: 200)
            }
        }
    }
    
    func showRequestReview() {
        if let twoWeek = defaults.object(forKey: REVIEW) as? Date {
            dispatchQ.asyncAfter(deadline: .now() + 1) { [self] in
                if date >= twoWeek {
                    SKStoreReviewController.requestReview()
                    let threeWeek = calendar.date(byAdding: .day, value: 21, to: date)
                    defaults.set(threeWeek, forKey: REVIEW)
                }
            }
        }
    }
    
    func historyPopup() {
        
        var attributes = EKAttributes.bottomFloat
        let statusBarColor: EKAttributes.StatusBar = defaults.object(forKey: DARK_COLOR) != nil ? .light : .dark
        let screenBackground: EKAttributes.BackgroundStyle.BlurStyle = defaults.object(forKey: DARK_COLOR) != nil ? .dark : .prominent
        
        if defaults.object(forKey: GREEN_COLOR) != nil {
            attributes.entryBackground =
                .gradient(gradient: .init(colors: [EKColor(UIColor(named: FOREST_GREEN)!), EKColor(UIColor(named: EMERALD_GREEN)!)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        } else if defaults.object(forKey: WHITE_COLOR) != nil {
            attributes.entryBackground =
                .gradient(gradient: .init(colors: [EKColor(UIColor.systemBlue), EKColor(UIColor.systemBlue)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        } else if defaults.object(forKey: PINK_COLOR) != nil {
            attributes.entryBackground =
                .gradient(gradient: .init(colors: [EKColor(UIColor(named: O_PINK)!), EKColor(UIColor(named: O_PINK)!)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        } else if defaults.object(forKey: ORANGE_COLOR) != nil {
            attributes.entryBackground =
                .gradient(gradient: .init(colors: [EKColor(UIColor(named: O_ORANGE)!), EKColor(UIColor(named: O_ORANGE)!)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        } else {
            attributes.entryBackground =
                .gradient(gradient: .init(colors: [EKColor(UIColor.systemBlue), EKColor(UIColor.systemBlue)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        }
        
        attributes.displayDuration = .infinity
        attributes.screenBackground = .visualEffect(style: screenBackground)
        attributes.statusBar = statusBarColor
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                defaults.set(templateId, forKey: ID)
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let tempHVC = storyboard.instantiateViewController(withIdentifier: "TempHVC")
                tempHVC.presentationController?.delegate = self
                self.present(tempHVC, animated: true, completion: nil)
            }
        }
        let popupMessage = EKPopUpMessage(title: title, description: description, button: button, action: action)
        let view = EKPopUpMessageView(with: popupMessage)
        attributes.lifecycleEvents.didDisappear = {
            dispatchQ.async {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
        SwiftEntryKit.display(entry: view, using: attributes)
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
        
        if defaults.object(forKey: END_TUTORIAL1) == nil {
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
        baseView.isHidden = true
        viewHeight.constant = 0
    }
    
    func setBackAction() {
        if defaults.object(forKey: BACK) != nil {
            memoTextField.resignFirstResponder()
            defaults.removeObject(forKey: BACK)
        }
    }
    
    func setupKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
                if defaults.object(forKey: EDIT_MEMO) == nil {
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
    
    func setup() {
        defaults.removeObject(forKey: ON_CHECK)
        defaults.removeObject(forKey: "cart")
        navigationItem.title = "買い物メモ"
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        
        hintView.alpha = 0
        baseView.isHidden = true
        topLineView2.isHidden = true
        statusView.isHidden = true
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
        memoTextField.delegate = self
        
        switch (UIScreen.main.nativeBounds.height) {
        case 1334:
            statusViewHeight.constant = 20
            topViewHeight.constant = 80
        case 2208:
            statusViewHeight.constant = 20
            topViewHeight.constant = 80
        default:
            break
        }
    }
    
    func setColor() {
        let separatorColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        let bannerColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let lineColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray4
        let labelColor: UIColor = defaults.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
        let tempLblColor: UIColor = defaults.object(forKey: WHITE_COLOR) != nil ? .systemGray : .systemGray5
        let btnColor: UIColor = defaults.object(forKey: WHITE_COLOR) != nil || defaults.object(forKey: DARK_COLOR) != nil ? .systemBlue : .white
        
        templateLabel.textColor = tempLblColor
        titleLabel.textColor = labelColor
        bannerView.backgroundColor = bannerColor
        tableView.separatorColor = separatorColor
        topLineView.backgroundColor = lineColor
        topLineView2.backgroundColor = lineColor
        templateButton.tintColor = labelColor
        tableView.backgroundColor = bannerColor
        deleteButton.tintColor = btnColor
        historyButton.tintColor = btnColor
        
        if defaults.object(forKey: GREEN_COLOR) != nil {
            statusView.backgroundColor = UIColor(named: "status_green")
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            templateButton.backgroundColor = UIColor(named: EMERALD_GREEN)
            let color = onSort ? UIColor.white : UIColor.systemGray4
            sortButton.tintColor = color
            
        } else if defaults.object(forKey: WHITE_COLOR) != nil {
            statusView.backgroundColor = UIColor(named: O_WHITE)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            templateButton.backgroundColor = UIColor(named: O_WHITE)
            let color = onSort ? UIColor.systemBlue : UIColor.systemGray
            sortButton.tintColor = color
            
        } else if defaults.object(forKey: PINK_COLOR) != nil {
            statusView.backgroundColor = UIColor(named: O_PINK)
            topView.backgroundColor = UIColor(named: O_PINK)
            templateButton.backgroundColor = UIColor(named: O_PINK)
            let color = onSort ? UIColor.white : UIColor.systemGray
            sortButton.tintColor = color
            
        } else if defaults.object(forKey: ORANGE_COLOR) != nil {
            statusView.backgroundColor = UIColor(named: O_ORANGE)
            topView.backgroundColor = UIColor(named: O_ORANGE_ALPHA)
            templateButton.backgroundColor = UIColor(named: O_ORANGE)
            let color = onSort ? UIColor.white : UIColor.systemGray
            sortButton.tintColor = color
            
        } else {
            statusView.backgroundColor = UIColor(named: "status_dark")
            topView.backgroundColor = UIColor(named: O_DARK2_ALPHA)
            templateButton.backgroundColor = UIColor.systemBlue
            let color = onSort ? UIColor.systemBlue : UIColor.systemGray
            sortButton.tintColor = color
        }
    }
    
    func bannerViewIsHidden() {
        let constant: CGFloat = defaults.object(forKey: PURCHASED) != nil ? 0 : 50
        bannerHeight.constant = constant
        viewHeight.constant = constant
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
