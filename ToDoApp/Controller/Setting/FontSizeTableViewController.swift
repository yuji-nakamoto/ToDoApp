//
//  FontSizeTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/08.
//

import UIKit

class FontSizeTableViewController: UITableViewController {

    @IBOutlet weak var font1Label: UILabel!
    @IBOutlet weak var font2Label: UILabel!
    @IBOutlet weak var font3Label: UILabel!
    @IBOutlet weak var font4Label: UILabel!
    @IBOutlet weak var font5Label: UILabel!
    @IBOutlet weak var font6Label: UILabel!
    @IBOutlet weak var font7Label: UILabel!
    @IBOutlet weak var font8Label: UILabel!
    @IBOutlet weak var checkmark1: UIImageView!
    @IBOutlet weak var checkmark2: UIImageView!
    @IBOutlet weak var checkmark3: UIImageView!
    @IBOutlet weak var checkmark4: UIImageView!
    @IBOutlet weak var checkmark5: UIImageView!
    @IBOutlet weak var checkmark6: UIImageView!
    @IBOutlet weak var checkmark7: UIImageView!
    @IBOutlet weak var checkmark8: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    lazy var labels = [font1Label,font2Label,font3Label,font4Label,font5Label,font6Label,font7Label,font8Label]
    lazy var checkmarks = [checkmark1,checkmark2,checkmark3,checkmark4,checkmark5,checkmark6,checkmark7,checkmark8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupColor()
        setSwipeBack()
        setCharacterSize()
        tableView.tableFooterView = UIView()
        navigationItem.title = "文字の大きさ"
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = userDefaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setCharacterSize() {
        
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            setChalacter1()
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            setChalacter2()
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            setChalacter3()
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
           setChalacter4()
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            setChalacter5()
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            setChalacter6()
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            setChalacter7()
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            setChalacter8()
        }
    }
    
    func setupColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        let tableViewColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        
        if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            backButton.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backButton.tintColor = .systemBlue
        } else {
            backButton.tintColor = .white
        }
        checkmarks.forEach({$0?.tintColor = color})
        labels.forEach({$0?.textColor = color})
        tableView.backgroundColor = tableViewColor
        tableView.separatorColor = separatorColor
    }
    
    private func setChalacter1() {
        checkmark1.isHidden = false
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13)})
    }
    
    private func setChalacter2() {
        checkmark1.isHidden = true
        checkmark2.isHidden = false
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13, weight: .medium)})
    }
    
    private func setChalacter3() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = false
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15)})
    }
    
    private func setChalacter4() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = false
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15, weight: .medium)})
    }
    
    private func setChalacter5() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = false
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17)})
    }
    
    private func setChalacter6() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = false
        checkmark7.isHidden = true
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17, weight: .medium)})
    }
    
    private func setChalacter7() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = false
        checkmark8.isHidden = true
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19)})
    }
    
    private func setChalacter8() {
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = false
        labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19, weight: .medium)})
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            UserDefaults.standard.set(true, forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter1()
        } else if indexPath.row == 1 {
            UserDefaults.standard.set(true, forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter2()
        } else if indexPath.row == 2 {
            UserDefaults.standard.set(true, forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter3()
        } else if indexPath.row == 3 {
            UserDefaults.standard.set(true, forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter4()
        } else if indexPath.row == 4 {
            UserDefaults.standard.set(true, forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter5()
        } else if indexPath.row == 5 {
            UserDefaults.standard.set(true, forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter6()
        } else if indexPath.row == 6 {
            UserDefaults.standard.set(true, forKey: BIG1)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: BIG2)
            setChalacter7()
        } else if indexPath.row == 7 {
            UserDefaults.standard.set(true, forKey: BIG2)
            UserDefaults.standard.removeObject(forKey: MIDIUM1)
            UserDefaults.standard.removeObject(forKey: MIDIUM2)
            UserDefaults.standard.removeObject(forKey: MIDIUM3)
            UserDefaults.standard.removeObject(forKey: MIDIUM4)
            UserDefaults.standard.removeObject(forKey: SMALL1)
            UserDefaults.standard.removeObject(forKey: SMALL2)
            UserDefaults.standard.removeObject(forKey: BIG1)
            setChalacter8()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        cell.backgroundColor = color
    }
}
