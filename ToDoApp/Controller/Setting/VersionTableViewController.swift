//
//  VersionTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit

class VersionTableViewController: UITableViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        navigationItem.title = "バージョンについて"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setColor()
        selectColor()
        setCharacterSize()
    }
    
    func setColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: GREEN_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        backButton.tintColor = color
    }
    
    func setCharacterSize() {
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 13)
            label2.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 15)
            label2.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 17)
            label2.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 19)
            label2.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
