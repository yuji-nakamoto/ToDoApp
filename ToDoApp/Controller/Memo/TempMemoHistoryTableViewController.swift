//
//  TempMemoHistoryTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/30.
//

import UIKit
import GoogleMobileAds
import RealmSwift

class TempMemoHistoryTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var topViewHeght: NSLayoutConstraint!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    private var tempMemoArray = [TemplateMemo]()
    var templateId = defaults.object(forKey: ID) as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        tableView.tableFooterView = UIView()
        fetchTemplateTitle()
        fetchTempHistory()
        defaults.set(true, forKey: "cart")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bannerViewIsHidden()
        selectColor()
        setColor()
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchTemplateTitle() {
        Template.fetchSelectedTemplate { [self] (bool, template) in
            if bool == true {
                titleLabel.text = template.name
            }
        }
    }
    
    func fetchTempHistory() {
        let realm = try! Realm()
        let tempMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(templateId)'").filter("date > 0")
        tempMemoArray.removeAll()
        tempMemoArray.append(contentsOf: tempMemos)
        tempMemoArray = tempMemoArray.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        tableView.reloadData()
    }
    
    func bannerViewIsHidden() {
        let constant: CGFloat = defaults.object(forKey: PURCHASED) != nil ? 0 : 50
        bannerHeight.constant = constant
    }
    
    func setColor() {
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        let bannerColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let labelColor: UIColor = UserDefaults.standard.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
        let lineColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray4

        bannerView.backgroundColor = bannerColor
        tableView.separatorColor = separatorColor
        titleLabel.textColor = labelColor
        tableView.backgroundColor = bannerColor
        topLineView.backgroundColor = lineColor

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
            topView.backgroundColor = UIColor(named: O_DARK3)
            dismissButton.tintColor = UIColor.systemBlue
        }
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension TempMemoHistoryTableViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempMemoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        cell.configureTempCell(tempMemoArray[indexPath.row])
        return cell
    }
}

extension TempMemoHistoryTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
