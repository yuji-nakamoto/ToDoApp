//
//  SettingTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit
import StoreKit

class SettingTableViewController: UITableViewController, SKStoreProductViewControllerDelegate {

    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var pushLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var inputSwitch: UISwitch!
    @IBOutlet weak var pushSwitch: UISwitch!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var goosminLogo: UIImageView!
    @IBOutlet weak var memoryLogo: UIImageView!
    @IBOutlet weak var manageLogo: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var useLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var appstoreLabel: UILabel!
    @IBOutlet weak var friendLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectColor()
        setCharacterSize()
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
    
    @IBAction func onThemeSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            themeLabel.text = "テーマカラー: グリーン"
            UserDefaults.standard.set(true, forKey: GREEN_COLOR)
            greenColor()
        } else {
            themeLabel.text = "テーマカラー: ホワイト"
            UserDefaults.standard.removeObject(forKey: GREEN_COLOR)
            whiteColor()
        }
    }
    
    // MARK: - Helpers
    
    func setCharacterSize() {
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 13)
            pushLabel.font = UIFont.systemFont(ofSize: 13)
            themeLabel.font = UIFont.systemFont(ofSize: 13)
            sizeLabel.font = UIFont.systemFont(ofSize: 13)
            characterLabel.font = UIFont.systemFont(ofSize: 13)
            useLabel.font = UIFont.systemFont(ofSize: 13)
            versionLabel.font = UIFont.systemFont(ofSize: 13)
            appstoreLabel.font = UIFont.systemFont(ofSize: 13)
            friendLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            pushLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            themeLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            sizeLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            characterLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            useLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            versionLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            appstoreLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            friendLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 15)
            pushLabel.font = UIFont.systemFont(ofSize: 15)
            themeLabel.font = UIFont.systemFont(ofSize: 15)
            sizeLabel.font = UIFont.systemFont(ofSize: 15)
            characterLabel.font = UIFont.systemFont(ofSize: 15)
            useLabel.font = UIFont.systemFont(ofSize: 15)
            versionLabel.font = UIFont.systemFont(ofSize: 15)
            appstoreLabel.font = UIFont.systemFont(ofSize: 15)
            friendLabel.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            pushLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            themeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            sizeLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            characterLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            useLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            versionLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            appstoreLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            friendLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 17)
            pushLabel.font = UIFont.systemFont(ofSize: 17)
            themeLabel.font = UIFont.systemFont(ofSize: 17)
            sizeLabel.font = UIFont.systemFont(ofSize: 17)
            characterLabel.font = UIFont.systemFont(ofSize: 17)
            useLabel.font = UIFont.systemFont(ofSize: 17)
            versionLabel.font = UIFont.systemFont(ofSize: 17)
            appstoreLabel.font = UIFont.systemFont(ofSize: 17)
            friendLabel.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            pushLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            themeLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            sizeLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            characterLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            useLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            versionLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            appstoreLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            friendLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 19)
            pushLabel.font = UIFont.systemFont(ofSize: 19)
            themeLabel.font = UIFont.systemFont(ofSize: 19)
            sizeLabel.font = UIFont.systemFont(ofSize: 19)
            characterLabel.font = UIFont.systemFont(ofSize: 19)
            useLabel.font = UIFont.systemFont(ofSize: 19)
            versionLabel.font = UIFont.systemFont(ofSize: 19)
            appstoreLabel.font = UIFont.systemFont(ofSize: 19)
            friendLabel.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            
            inputLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            pushLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            themeLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            sizeLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            characterLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            useLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            versionLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            appstoreLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            friendLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        sizeLabel.text = ""
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            sizeLabel.text = "小A"
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            sizeLabel.text = "小B"
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            sizeLabel.text = "中A"
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            sizeLabel.text = "中B"
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            sizeLabel.text = "中C"
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            sizeLabel.text = "中D"
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            sizeLabel.text = "大A"
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            sizeLabel.text = "大B"
        }
    }
    
    func setup() {
        
        if UserDefaults.standard.object(forKey: ON_INPUT) != nil {
            inputLabel.text = "入力候補を表示する"
            inputSwitch.isOn = true
        } else {
            inputLabel.text = "入力候補を表示しない"
            inputSwitch.isOn = false
        }
        
        if UserDefaults.standard.object(forKey: ON_PUSH) != nil {
            pushLabel.text = "カート履歴の通知を行う"
            pushSwitch.isOn = true
        } else {
            pushLabel.text = "カート履歴の通知を行わない"
            pushSwitch.isOn = false
        }
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            themeLabel.text = "テーマカラー: グリーン"
            themeSwitch.isOn = true
        } else {
            themeLabel.text = "テーマカラー: ホワイト"
            themeSwitch.isOn = false
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
        
        present( productViewController, animated: true, completion: {() -> Void in
            let productID = "1538421002"
            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct( withParameters: parameters, completionBlock: {(Bool, NSError) -> Void in
                print(Bool)
            })
        })
    }
    
    func showMemoryStore() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present( productViewController, animated: true, completion: {() -> Void in
            let productID = "1542502045"
            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct( withParameters: parameters, completionBlock: {(Bool, NSError) -> Void in
                print(Bool)
            })
        })
    }
    
    func showManageStore() {
        let productViewController = SKStoreProductViewController()
        productViewController.delegate = self
        
        present( productViewController, animated: true, completion: {() -> Void in
            let productID = "1540427984"
            let parameters:Dictionary = [SKStoreProductParameterITunesItemIdentifier: productID]
            productViewController.loadProduct( withParameters: parameters, completionBlock: {(Bool, NSError) -> Void in
                print(Bool)
            })
        })
    }
    
    func showActivity() {
        let activityItems = ["かんたん入力！誰でも使える買い物メモアプリ　メモリ Apple Watch対応", URL(string: "https://apps.apple.com/us/app/%E3%83%A1%E3%83%A2%E3%83%AA%E3%83%BC-%E3%81%8B%E3%82%93%E3%81%9F%E3%82%93%E5%85%A5%E5%8A%9B-%E8%AA%B0%E3%81%A7%E3%82%82%E4%BD%BF%E3%81%88%E3%82%8B%E8%B2%B7%E3%81%84%E7%89%A9%E3%83%A1%E3%83%A2%E3%82%A2%E3%83%97%E3%83%AA/id1542502045") as Any] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
    // MARK: - Table view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 && indexPath.row == 2 {
            SKStoreReviewController.requestReview()
        } else if indexPath.section == 1 && indexPath.row == 3 {
            showActivity()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            showGoosminStore()
        } else if indexPath.section == 2 && indexPath.row == 1 {
            showMemoryStore()
        } else if indexPath.section == 2 && indexPath.row == 2 {
            showManageStore()
        }
    }
}
