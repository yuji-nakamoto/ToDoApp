//
//  ColorTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/13.
//

import UIKit

class ColorTableViewController: UITableViewController {
    
    @IBOutlet weak var colorLabel1: UILabel!
    @IBOutlet weak var colorLabel2: UILabel!
    @IBOutlet weak var colorLabel3: UILabel!
    @IBOutlet weak var colorLabel4: UILabel!
    @IBOutlet weak var checkmark1: UIImageView!
    @IBOutlet weak var checkmark2: UIImageView!
    @IBOutlet weak var checkmark3: UIImageView!
    @IBOutlet weak var checkmark4: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    lazy var labels = [colorLabel1,colorLabel2,colorLabel3,colorLabel4]
    lazy var checkmarks = [checkmark1,checkmark2,checkmark3,checkmark4]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        tableView.tableFooterView = UIView()
        navigationItem.title = "テーマカラー"
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        setFont()
        selectColor()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = userDefaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    private func setupColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        let tableViewColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        
        labels.forEach({$0?.textColor = color})
        checkmarks.forEach({$0?.tintColor = color})
        tableView.backgroundColor = tableViewColor
        tableView.separatorColor = separatorColor
        setNeedsStatusBarAppearanceUpdate()
        tableView.reloadData()
    }
    
    func setup() {
        
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            checkmark1.isHidden = false
            checkmark2.isHidden = true
            checkmark3.isHidden = true
            checkmark4.isHidden = true
            backButton.tintColor = .white
            setupColor()
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            checkmark1.isHidden = true
            checkmark2.isHidden = false
            checkmark3.isHidden = true
            checkmark4.isHidden = true
            backButton.tintColor = UIColor(named: O_BLACK)
            setupColor()
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = false
            checkmark4.isHidden = true
            backButton.tintColor = .white
            setupColor()
        } else {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = true
            checkmark4.isHidden = false
            backButton.tintColor = .systemBlue
            setupColor()
        }
    }
    
    func setFont() {
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 13)})
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 13, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 15)})
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 15, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 17)})
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 17, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 19)})
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            labels.forEach({$0!.font = UIFont.systemFont(ofSize: 19, weight: .medium)})
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        cell.backgroundColor = color
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            checkmark1.isHidden = false
            checkmark2.isHidden = true
            checkmark3.isHidden = true
            checkmark4.isHidden = true
            UserDefaults.standard.set(true, forKey: GREEN_COLOR)
            UserDefaults.standard.removeObject(forKey: WHITE_COLOR)
            UserDefaults.standard.removeObject(forKey: PINK_COLOR)
            UserDefaults.standard.removeObject(forKey: DARK_COLOR)
            backButton.tintColor = .white
            selectColor()
            setupColor()
        } else if indexPath.row == 1 {
            checkmark1.isHidden = true
            checkmark2.isHidden = false
            checkmark3.isHidden = true
            checkmark4.isHidden = true
            UserDefaults.standard.set(true, forKey: WHITE_COLOR)
            UserDefaults.standard.removeObject(forKey: GREEN_COLOR)
            UserDefaults.standard.removeObject(forKey: PINK_COLOR)
            UserDefaults.standard.removeObject(forKey: DARK_COLOR)
            backButton.tintColor = UIColor(named: O_BLACK)
            selectColor()
            setupColor()
        } else if indexPath.row == 2 {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = false
            checkmark4.isHidden = true
            UserDefaults.standard.set(true, forKey: PINK_COLOR)
            UserDefaults.standard.removeObject(forKey: GREEN_COLOR)
            UserDefaults.standard.removeObject(forKey: WHITE_COLOR)
            UserDefaults.standard.removeObject(forKey: DARK_COLOR)
            backButton.tintColor = .white
            selectColor()
            setupColor()
        } else {
            checkmark1.isHidden = true
            checkmark2.isHidden = true
            checkmark3.isHidden = true
            checkmark4.isHidden = false
            UserDefaults.standard.set(true, forKey: DARK_COLOR)
            UserDefaults.standard.removeObject(forKey: GREEN_COLOR)
            UserDefaults.standard.removeObject(forKey: WHITE_COLOR)
            UserDefaults.standard.removeObject(forKey: PINK_COLOR)
            backButton.tintColor = .systemBlue
            selectColor()
            setupColor()
        }
    }
}
