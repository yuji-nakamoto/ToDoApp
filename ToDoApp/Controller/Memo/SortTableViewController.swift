//
//  SortTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/12.
//

import UIKit
import GoogleMobileAds

class SortTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        setColor()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setColor() {
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        let bannerColor: UIColor = userDefaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        bannerView.backgroundColor = bannerColor
        tableView.separatorColor = separatorColor
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: EMERALD_GREEN_ALPHA)
            dismissButton.tintColor = UIColor.white
            tableView.backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            titleLabel.textColor = UIColor(named: O_BLACK)
            topView.backgroundColor = UIColor(named: O_WHITE_ALPHA)
            dismissButton.tintColor = UIColor(named: O_BLACK)
            tableView.backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: O_PINK)
            dismissButton.tintColor = UIColor.white
            tableView.backgroundColor = .systemBackground
        } else {
            titleLabel.textColor = UIColor.white
            topView.backgroundColor = UIColor(named: O_DARK3)
            dismissButton.tintColor = UIColor.systemBlue
            tableView.backgroundColor = UIColor(named: O_DARK1)
        }
    }
    
    func setupBanner() {
        bannerView.adUnitID = "ca-app-pub-4750883229624981/1980065426"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension SortTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1")
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3")
        
        let checkmark1 = cell1?.viewWithTag(1) as! UIImageView
        let checkmark2 = cell2?.viewWithTag(2) as! UIImageView
        let checkmark3 = cell3?.viewWithTag(3) as! UIImageView
        let label1 = cell1?.viewWithTag(4) as! UILabel
        let label2 = cell2?.viewWithTag(5) as! UILabel
        let label3 = cell3?.viewWithTag(6) as! UILabel
        
        if UserDefaults.standard.object(forKey: DATE_ASCE) != nil {
            checkmark1.isHidden = true
            checkmark2.isHidden = false
            checkmark3.isHidden = true
        } else if UserDefaults.standard.object(forKey: ITEM_SORT) != nil {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = false
        } else {
            checkmark1.isHidden = false
            checkmark2.isHidden = true
            checkmark3.isHidden = true
        }
        
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            label1.font = UIFont.systemFont(ofSize: 13)
            label2.font = UIFont.systemFont(ofSize: 13)
            label3.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            label1.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            label1.font = UIFont.systemFont(ofSize: 15)
            label2.font = UIFont.systemFont(ofSize: 15)
            label3.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            label1.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            label1.font = UIFont.systemFont(ofSize: 17)
            label2.font = UIFont.systemFont(ofSize: 17)
            label3.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            label1.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            label1.font = UIFont.systemFont(ofSize: 19)
            label2.font = UIFont.systemFont(ofSize: 19)
            label3.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            label1.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
        
        let cellColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        cell1?.backgroundColor = cellColor
        cell2?.backgroundColor = cellColor
        cell3?.backgroundColor = cellColor
        checkmark1.tintColor = color
        checkmark2.tintColor = color
        checkmark3.tintColor = color
        label1.textColor = color
        label2.textColor = color
        label3.textColor = color
        
        if indexPath.row == 0 {
            return cell1!
        } else if indexPath.row == 1 {
            return cell2!
        }
        return cell3!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1")
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3")
        
        let checkmark1 = cell1?.viewWithTag(1) as! UIImageView
        let checkmark2 = cell2?.viewWithTag(2) as! UIImageView
        let checkmark3 = cell3?.viewWithTag(3) as! UIImageView

        if indexPath.row == 0 {
            checkmark1.isHidden = false
            checkmark2.isHidden = true
            checkmark3.isHidden = true
            UserDefaults.standard.removeObject(forKey: DATE_ASCE)
            UserDefaults.standard.removeObject(forKey: ITEM_SORT)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tableView.reloadData()
            }
        } else if indexPath.row == 1 {
            checkmark1.isHidden = true
            checkmark2.isHidden = false
            checkmark3.isHidden = true
            UserDefaults.standard.set(true, forKey: DATE_ASCE)
            UserDefaults.standard.removeObject(forKey: ITEM_SORT)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tableView.reloadData()
            }
        } else {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = false
            UserDefaults.standard.removeObject(forKey: DATE_ASCE)
            UserDefaults.standard.set(true, forKey:ITEM_SORT)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                tableView.reloadData()
            }
        }
    }
}

extension SortTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
