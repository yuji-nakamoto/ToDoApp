//
//  SettingTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit
import SwiftyStoreKit
import StoreKit
import PKHUD

class SettingTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var pushLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var inputSwitch: UISwitch!
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var goosminLogo: UIImageView!
    @IBOutlet weak var memoryLogo: UIImageView!
    @IBOutlet weak var manageLogo: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var appstoreLabel: UILabel!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var babyLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var adsLabel: UILabel!
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    @IBOutlet weak var arrow4: UIImageView!
    @IBOutlet weak var arrow5: UIImageView!
    @IBOutlet weak var arrow6: UIImageView!
    @IBOutlet weak var arrow7: UIImageView!
    @IBOutlet weak var arrow8: UIImageView!
    @IBOutlet weak var arrow9: UIImageView!
    @IBOutlet weak var arrow10: UIImageView!
    
    lazy var labels = [inputLabel,pushLabel,themeLabel,colorLabel,sizeLabel,characterLabel,useLabel,versionLabel,appstoreLabel,friendLabel,babyLabel,memoLabel,moneyLabel,adsLabel]
    lazy var arrows = [arrow1,arrow2,arrow3,arrow4,arrow5,arrow6,arrow7,arrow8,arrow9,arrow10]
    private let productId = "xmlApp.ToDoApp.nonConsumable"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.set(true, forKey: SETTING_VC)
        setupThemeLabel()
        selectColor()
        setupColor()
        setFontSize()
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = defaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    // MARK: - Actions
    
    @IBAction func onInputSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            inputLabel.text = "入力候補を表示する"
            UserDefaults.standard.set(true, forKey: ON_INPUT)
        } else {
            inputLabel.text = "入力候補を表示しない"
            UserDefaults.standard.removeObject(forKey: ON_INPUT)
        }
    }
    
    @IBAction func onPushSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            pushLabel.text = "カート履歴の通知を行う"
            UserDefaults.standard.set(true, forKey: ON_PUSH)
        } else {
            pushLabel.text = "カート履歴の通知を行わない"
            UserDefaults.standard.removeObject(forKey: ON_PUSH)
        }
    }
    
    // MARK: - Helpers
    
    func setFontSize() {
        
        if defaults.object(forKey: SMALL1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13)})
        } else if defaults.object(forKey: SMALL2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13, weight: .medium)})
        } else if defaults.object(forKey: MIDIUM1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15)})
        } else if defaults.object(forKey: MIDIUM2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15, weight: .medium)})
        } else if defaults.object(forKey: MIDIUM3) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17)})
        } else if defaults.object(forKey: MIDIUM4) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17, weight: .medium)})
        } else if defaults.object(forKey: BIG1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19)})
        } else if defaults.object(forKey: BIG2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19, weight: .medium)})
        }
        
        sizeLabel.text = ""
        if defaults.object(forKey: SMALL1) != nil {
            sizeLabel.text = "小A"
        } else if defaults.object(forKey: SMALL2) != nil {
            sizeLabel.text = "小B"
        } else if defaults.object(forKey: MIDIUM1) != nil {
            sizeLabel.text = "中A"
        } else if defaults.object(forKey: MIDIUM2) != nil {
            sizeLabel.text = "中B"
        } else if defaults.object(forKey: MIDIUM3) != nil {
            sizeLabel.text = "中C"
        } else if defaults.object(forKey: MIDIUM4) != nil {
            sizeLabel.text = "中D"
        } else if defaults.object(forKey: BIG1) != nil {
            sizeLabel.text = "大A"
        } else if defaults.object(forKey: BIG2) != nil {
            sizeLabel.text = "大B"
        }
    }
    
    func setupColor() {
        
        let color: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        let arrowColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .white : .systemGray3
        let tableColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK3)! : UIColor(named: O_WHITE)!
        let separatorColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3

        labels.forEach({$0?.textColor = color})
        arrows.forEach({$0?.tintColor = arrowColor})
        tableView.backgroundColor = tableColor
        tableView.separatorColor = separatorColor
    }
    
    func setupThemeLabel() {
        
        if defaults.object(forKey: GREEN_COLOR) != nil {
            colorLabel.text = "グリーン"
            inputSwitch.onTintColor = UIColor(named: EMERALD_GREEN)
            pushSwitch.onTintColor = UIColor(named: EMERALD_GREEN)
        } else if defaults.object(forKey: WHITE_COLOR) != nil {
            colorLabel.text = "ホワイト"
            inputSwitch.onTintColor = UIColor.systemBlue
            pushSwitch.onTintColor = UIColor.systemBlue
        } else if defaults.object(forKey: PINK_COLOR) != nil {
            colorLabel.text = "ピンク"
            inputSwitch.onTintColor = UIColor(named: O_PINK)
            pushSwitch.onTintColor = UIColor(named: O_PINK)
        } else if defaults.object(forKey: ORANGE_COLOR) != nil {
            colorLabel.text = "オレンジ"
            inputSwitch.onTintColor = UIColor(named: O_ORANGE)
            pushSwitch.onTintColor = UIColor(named: O_ORANGE)
        } else {
            colorLabel.text = "ダーク"
            inputSwitch.onTintColor = UIColor.systemBlue
            pushSwitch.onTintColor = UIColor.systemBlue
        }
    }
    
    func setup() {
        
        if defaults.object(forKey: ON_INPUT) != nil {
            inputLabel.text = "入力候補を表示する"
            inputSwitch.isOn = true
        } else {
            inputLabel.text = "入力候補を表示しない"
            inputSwitch.isOn = false
        }
        
        if defaults.object(forKey: ON_PUSH) != nil {
            pushLabel.text = "カート履歴の通知を行う"
            pushSwitch.isOn = true
        } else {
            pushLabel.text = "カート履歴の通知を行わない"
            pushSwitch.isOn = false
        }
        
        navigationItem.title = "設定"
        goosminLogo.layer.cornerRadius = 7
        memoryLogo.layer.cornerRadius = 7
        manageLogo.layer.cornerRadius = 7
        memoryLogo.layer.borderWidth = 1
        memoryLogo.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func showGoosminStore() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present(productViewController, animated: true) {
            let productID = "1538421002"
            let param: Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct(withParameters: param, completionBlock: nil)
        }
    }
    
    func showMemoryStore() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present(productViewController, animated: true) {
            let productID = "1542502045"
            let param: Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct(withParameters: param, completionBlock: nil)
        }
    }
    
    func showManageStore() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present(productViewController, animated: true) {
            let productID = "1540427984"
            let param: Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct(withParameters: param, completionBlock: nil)
        }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        dispatchQ.asyncAfter(deadline: .now() + 0.1) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func showActivity() {
        let activityItems = ["かんたん入力！誰でも使える買い物メモアプリ　メモリ Apple Watch対応", URL(string: "https://apps.apple.com/us/app/%E3%83%A1%E3%83%A2%E3%83%AA%E3%83%BC-%E3%81%8B%E3%82%93%E3%81%9F%E3%82%93%E5%85%A5%E5%8A%9B-%E8%AA%B0%E3%81%A7%E3%82%82%E4%BD%BF%E3%81%88%E3%82%8B%E8%B2%B7%E3%81%84%E7%89%A9%E3%83%A1%E3%83%A2%E3%82%A2%E3%83%97%E3%83%AA/id1542502045") as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
           if !completed {
            self.setNeedsStatusBarAppearanceUpdate()
           }
        }
        self.present(activityVC, animated: true)
    }
    
    func purchaseProduct() {
        HUD.show(.progress)
        SwiftyStoreKit.purchaseProduct(productId, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let product):
                self.setNeedsStatusBarAppearanceUpdate()
                defaults.set(true, forKey: PURCHASED)
                HUD.flash(.labeledSuccess(title: "", subtitle: ""), delay: 1)
                print("Purchase Success: \(product.productId)")
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. \(error.localizedDescription)")
                    self.setNeedsStatusBarAppearanceUpdate()
                    HUD.hide()
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: print("Cancelled")
                    self.setNeedsStatusBarAppearanceUpdate()
                    HUD.hide()
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func restoreProduct() {
        HUD.show(.progress)
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                self.setNeedsStatusBarAppearanceUpdate()
                HUD.flash(.labeledError(title: "復元に失敗しました", subtitle: ""), delay: 1)
            } else if results.restoredPurchases.count > 0 {
                
                for purchase in results.restoredPurchases {
                    if purchase.productId == self.productId {
                        defaults.set(true, forKey: PURCHASED)
                        self.setNeedsStatusBarAppearanceUpdate()
                        print("Restore Success: \(results.restoredPurchases)")
                        HUD.flash(.labeledSuccess(title: "復元しました", subtitle: ""), delay: 1)
                    }
                }
            } else {
                HUD.flash(.labeledError(title: "復元するものがありません", subtitle: ""), delay: 1)
                self.setNeedsStatusBarAppearanceUpdate()
                print("Nothing to Restore")
            }
        }
    }
    
    func selectPurchase() {
        let priceText = defaults.object(forKey: PURCHASED) != nil ? "購入済みです" : "価格: ¥250"
        let alert = UIAlertController(title: "広告を非表示にする", message: priceText, preferredStyle: .alert)
        let purchase = UIAlertAction(title: "購入する", style: UIAlertAction.Style.default) { [self] (alert) in
            purchaseProduct()
        }
        let restore = UIAlertAction(title: "復元する", style: UIAlertAction.Style.default) { [self] (alert) in
            restoreProduct()
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel) { [self] (alert) in
            setNeedsStatusBarAppearanceUpdate()
        }
        
        if defaults.object(forKey: PURCHASED) != nil {
            alert.addAction(restore)
            alert.addAction(cancel)
        } else {
            alert.addAction(purchase)
            alert.addAction(restore)
            alert.addAction(cancel)
        }
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        cell.backgroundColor = color
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 2 {
            SKStoreReviewController.requestReview()
        } else if indexPath.section == 1 && indexPath.row == 3 {
            showActivity()
        } else if indexPath.section == 1 && indexPath.row == 4 {
            selectPurchase()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            showGoosminStore()
        } else if indexPath.section == 2 && indexPath.row == 1 {
            showMemoryStore()
        } else if indexPath.section == 2 && indexPath.row == 2 {
            showManageStore()
        }
    }
}

extension SettingTableViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    setNeedsStatusBarAppearanceUpdate()
  }
}
