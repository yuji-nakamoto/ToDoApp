//
//  CharacterSizeTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/08.
//

import UIKit

class CharacterSizeTableViewController: UITableViewController {

    @IBOutlet weak var character1Label: UILabel!
    @IBOutlet weak var character2Label: UILabel!
    @IBOutlet weak var character3Label: UILabel!
    @IBOutlet weak var character4Label: UILabel!
    @IBOutlet weak var character5Label: UILabel!
    @IBOutlet weak var character6Label: UILabel!
    @IBOutlet weak var character7Label: UILabel!
    @IBOutlet weak var character8Label: UILabel!
    @IBOutlet weak var checkmark1: UIImageView!
    @IBOutlet weak var checkmark2: UIImageView!
    @IBOutlet weak var checkmark3: UIImageView!
    @IBOutlet weak var checkmark4: UIImageView!
    @IBOutlet weak var checkmark5: UIImageView!
    @IBOutlet weak var checkmark6: UIImageView!
    @IBOutlet weak var checkmark7: UIImageView!
    @IBOutlet weak var checkmark8: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        setSwipeBack()
        setCharacterSize()
        tableView.tableFooterView = UIView()
        navigationItem.title = "文字の大きさ"
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setCharacterSize() {
        
        checkmark1.isHidden = true
        checkmark2.isHidden = true
        checkmark3.isHidden = true
        checkmark4.isHidden = true
        checkmark5.isHidden = true
        checkmark6.isHidden = true
        checkmark7.isHidden = true
        checkmark8.isHidden = true
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
    
    func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            backButton.tintColor = UIColor.white
        } else {
            backButton.tintColor = UIColor(named: O_BLACK)
        }
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
        character1Label.font = UIFont.systemFont(ofSize: 13)
        character2Label.font = UIFont.systemFont(ofSize: 13)
        character3Label.font = UIFont.systemFont(ofSize: 13)
        character4Label.font = UIFont.systemFont(ofSize: 13)
        character5Label.font = UIFont.systemFont(ofSize: 13)
        character6Label.font = UIFont.systemFont(ofSize: 13)
        character7Label.font = UIFont.systemFont(ofSize: 13)
        character8Label.font = UIFont.systemFont(ofSize: 13)
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
        character1Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character2Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character3Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character4Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character5Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character6Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character7Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        character8Label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
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
        character1Label.font = UIFont.systemFont(ofSize: 15)
        character2Label.font = UIFont.systemFont(ofSize: 15)
        character3Label.font = UIFont.systemFont(ofSize: 15)
        character4Label.font = UIFont.systemFont(ofSize: 15)
        character5Label.font = UIFont.systemFont(ofSize: 15)
        character6Label.font = UIFont.systemFont(ofSize: 15)
        character7Label.font = UIFont.systemFont(ofSize: 15)
        character8Label.font = UIFont.systemFont(ofSize: 15)
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
        character1Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character2Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character3Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character4Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character5Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character6Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character7Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        character8Label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
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
        character1Label.font = UIFont.systemFont(ofSize: 17)
        character2Label.font = UIFont.systemFont(ofSize: 17)
        character3Label.font = UIFont.systemFont(ofSize: 17)
        character4Label.font = UIFont.systemFont(ofSize: 17)
        character5Label.font = UIFont.systemFont(ofSize: 17)
        character6Label.font = UIFont.systemFont(ofSize: 17)
        character7Label.font = UIFont.systemFont(ofSize: 17)
        character8Label.font = UIFont.systemFont(ofSize: 17)
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
        character1Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character2Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character3Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character4Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character5Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character6Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character7Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        character8Label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
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
        character1Label.font = UIFont.systemFont(ofSize: 19)
        character2Label.font = UIFont.systemFont(ofSize: 19)
        character3Label.font = UIFont.systemFont(ofSize: 19)
        character4Label.font = UIFont.systemFont(ofSize: 19)
        character5Label.font = UIFont.systemFont(ofSize: 19)
        character6Label.font = UIFont.systemFont(ofSize: 19)
        character7Label.font = UIFont.systemFont(ofSize: 19)
        character8Label.font = UIFont.systemFont(ofSize: 19)
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
        character1Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character2Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character3Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character4Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character5Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character6Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character7Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        character8Label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
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
}
