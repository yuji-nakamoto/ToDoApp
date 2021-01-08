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
    
    private var tempMemoArray = [TemplateMemo]()
    var templateId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        tableView.tableFooterView = UIView()
        fetchTemplate()
        fetchTempHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectColor()
        setColor()
    }
    
    private func fetchTemplate() {
        
        Template.fetchSelectedTemplate { [self] (bool, template) in
            if bool == true {
                titleLabel.text = template.name
            }
        }
    }
    
    private func fetchTempHistory() {
        
        let realm = try! Realm()
        let tempMemos = realm.objects(TemplateMemo.self).filter("templateId == '\(templateId)'").filter("date > 0")
        tempMemoArray.removeAll()
        tempMemoArray.append(contentsOf: tempMemos)
        tempMemoArray = tempMemoArray.sorted(by: { (a, b) -> Bool in
            return a.date > b.date
        })
        tableView.reloadData()
    }
    
    private func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            dismissButton.tintColor = UIColor.white
        } else {
            titleLabel.textColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            dismissButton.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    private func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
