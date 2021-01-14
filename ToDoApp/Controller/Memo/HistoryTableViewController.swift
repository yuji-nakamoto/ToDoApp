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
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sortButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sortVC = storyboard.instantiateViewController(withIdentifier: "SortVC")
        sortVC.presentationController?.delegate = self
        self.present(sortVC, animated: true, completion: nil)
    }
    
    func fetchHistory() {
        let realm = try! Realm()
        let historeis = realm.objects(History.self)
        historyArray.removeAll()
        historyArray.append(contentsOf: historeis)
        
        if UserDefaults.standard.object(forKey: DATE_ASCE) != nil {
            historyArray = historyArray.sorted(by: { (a, b) -> Bool in
                return a.date < b.date
            })
        } else if UserDefaults.standard.object(forKey: ITEM_SORT) != nil {
            historyArray = historyArray.sorted(by: { (a, b) -> Bool in
                return a.name < b.name
            })
        } else {
            historyArray = historyArray.sorted(by: { (a, b) -> Bool in
                return a.date > b.date
            })
        }
        tableView.reloadData()
    }
    
    func setup() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        sortButton.layer.cornerRadius = 35 / 2
        sortButton.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        sortButton.layer.shadowColor = UIColor.black.cgColor
        sortButton.layer.shadowOpacity = 0.3
        sortButton.layer.shadowRadius = 4
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: WHITE_COLOR) == nil ? .white : UIColor(named: O_BLACK)!
        let bannerColor: UIColor = userDefaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        bannerView.backgroundColor = bannerColor
        dismissButton.tintColor = color
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            sortButton.backgroundColor = UIColor(named: EMERALD_GREEN)
            sortButton.tintColor = .white
            dismissButton.tintColor = .white
            tableView.backgroundColor = .systemBackground
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            sortButton.backgroundColor = .white
            sortButton.tintColor = UIColor(named: O_BLACK)
            dismissButton.tintColor = UIColor(named: O_BLACK)
            tableView.backgroundColor = .systemBackground
            titleLabel.textColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            sortButton.backgroundColor = UIColor(named: O_PINK)
            sortButton.tintColor = .white
            dismissButton.tintColor = .white
            tableView.backgroundColor = .systemBackground
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: O_PINK)
        } else {
            sortButton.backgroundColor = .systemBlue
            sortButton.tintColor = .white
            dismissButton.tintColor = .systemBlue
            tableView.backgroundColor = UIColor(named: O_DARK1)
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: O_DARK3)
        }
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

extension HistoryTableViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    fetchHistory()
  }
}
