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
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    private var historyArray = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHistory()
        selectColor()
        setColor()
    }
    
    func fetchHistory() {
        
        let realm = try! Realm()
        let historeis = realm.objects(History.self)
        historyArray.removeAll()
        historyArray.append(contentsOf: historeis)
        historyArray = historyArray.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        tableView.reloadData()
    }
    
    func setup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.titleTextAttributes
            = [.foregroundColor: UIColor.white as Any,]
        navigationItem.title = "カート履歴"
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        dismissButton.tintColor = color
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension HistoryTableViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HistoryTableViewCell
        
        cell.historyVC = self
        cell.history = historyArray[indexPath.row]
        cell.configureCell(historyArray[indexPath.row])
        return cell
    }
}

extension HistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: O_BLACK) as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 15) as Any]
        return NSAttributedString(string: "カート履歴はありません", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.systemGray2 as Any, .font: UIFont(name: "HiraMaruProN-W4", size: 13) as Any]
        return NSAttributedString(string: "メモをチェックすることで、履歴に表示されます", attributes: attributes)
    }
}
