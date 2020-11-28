//
//  SettingTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var checkSwitch: UISwitch!
    @IBOutlet weak var inputSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    @IBAction func onCheckSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            checkLabel.text = "チェック時の振動オン"
            UserDefaults.standard.set(true, forKey: ON_CHECK)
        } else {
            checkLabel.text = "チェック時の振動オフ"
            UserDefaults.standard.removeObject(forKey: ON_CHECK)
        }
    }
    
    @IBAction func onInputSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            inputLabel.text = "入力候補を表示する"
            UserDefaults.standard.set(true, forKey: ON_INPUT)
        } else {
            inputLabel.text = "入力候補を表示しない"
            UserDefaults.standard.removeObject(forKey: ON_INPUT)
        }
    }
    
    private func setup() {
        
        if UserDefaults.standard.object(forKey: ON_CHECK) != nil {
            checkLabel.text = "チェック時の振動オン"
            checkSwitch.isOn = true
        } else {
            checkLabel.text = "チェック時の振動オフ"
            checkSwitch.isOn = false
        }
        
        if UserDefaults.standard.object(forKey: ON_INPUT) != nil {
            inputLabel.text = "入力候補を表示する"
            inputSwitch.isOn = true
        } else {
            inputLabel.text = "入力候補を表示しない"
            inputSwitch.isOn = false
        }
        navigationItem.title = "設定"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
