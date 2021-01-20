//
//  HistoryTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/30.
//

import UIKit
import GoogleMobileAds
import EmptyDataSet_Swift
import RealmSwift

class HistoryTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
        
    private let histories = try! Realm().objects(History.self).sorted(byKeyPath: "timestamp", ascending: false)
    private var sectionNames1: [String] {
        return Set(histories.value(forKeyPath: "timestamp") as! [String]).sorted { (a, b) -> Bool in
            a > b
        }
    }
    private var sectionNames2: [String] {
        return Set(histories.value(forKeyPath: "timestamp") as! [String]).sorted { (a, b) -> Bool in
            a < b
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectColor()
        setColor()
        bannerViewIsHidden()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        if defaults.object(forKey: DATE_ASCE) != nil {
            defaults.removeObject(forKey: DATE_ASCE)
            setup()
            tableView.reloadData()
        } else {
            defaults.set(true, forKey: DATE_ASCE)
            setup()
            tableView.reloadData()
        }
    }
        
    // MARK: - Helpers
    
    func bannerViewIsHidden() {
        let constant: CGFloat = defaults.object(forKey: PURCHASED) != nil ? 0 : 50
        bannerHeight.constant = constant
    }
    
    func setup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        
        sortButton.layer.cornerRadius = 35 / 2
        sortButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        sortButton.layer.shadowColor = UIColor.black.cgColor
        sortButton.layer.shadowOpacity = 0.3
        sortButton.layer.shadowRadius = 4
        
        let sortTitle = defaults.object(forKey: DATE_ASCE) != nil ? "日付順（昇順）" : "日付順（降順）"
        sortLabel.text = sortTitle
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setColor() {
        let labelColor: UIColor = UserDefaults.standard.object(forKey: WHITE_COLOR) != nil ? UIColor(named: O_BLACK)! : .white
        let bannerColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        
        bannerView.backgroundColor = bannerColor
        sortButton.tintColor = labelColor
        sortLabel.textColor = labelColor
        titleLabel.textColor = labelColor
        tableView.backgroundColor = bannerColor
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            sortButton.backgroundColor = UIColor(named: EMERALD_GREEN)
            dismissButton.tintColor = .white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            sortButton.backgroundColor = .white
            dismissButton.tintColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            sortButton.backgroundColor = UIColor(named: O_PINK)
            dismissButton.tintColor = .white
            topView.backgroundColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
            sortButton.backgroundColor = UIColor(named: O_ORANGE)
            dismissButton.tintColor = .white
            topView.backgroundColor = UIColor(named: O_ORANGE_ALPHA)
        } else {
            sortButton.backgroundColor = .systemBlue
            dismissButton.tintColor = .systemBlue
            topView.backgroundColor = UIColor(named: O_DARK3)
        }
    }
}

// MARK: - Table view

extension HistoryTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNames1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if defaults.object(forKey: DATE_ASCE) != nil {
            return sectionNames2[section]
        }
        return sectionNames1[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if defaults.object(forKey: DATE_ASCE) != nil {
            return histories.filter("timestamp == %@", sectionNames2[section]).count
        }
        return histories.filter("timestamp == %@", sectionNames1[section]).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        let history = defaults.object(forKey: DATE_ASCE) != nil ? histories.filter("timestamp == %@", sectionNames2[indexPath.section])[indexPath.row] : histories.filter("timestamp == %@", sectionNames1[indexPath.section])[indexPath.row]
        
        cell.historyVC = self
        cell.history = history
        cell.configureCell(history)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let history = defaults.object(forKey: DATE_ASCE) != nil ? histories.filter("timestamp == %@", sectionNames2[indexPath.section])[indexPath.row].name : histories.filter("timestamp == %@", sectionNames1[indexPath.section])[indexPath.row].name
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            UserDefaults.standard.set(history, forKey: ITEM_NAME)
            dismiss(animated: true)
        }
    }
}

extension HistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "カート履歴はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "メモをチェックすることで、履歴に表示されます", attributes: attributes)
    }
}

extension HistoryTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
