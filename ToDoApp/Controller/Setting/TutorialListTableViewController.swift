//
//  TutorialListTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit

class TutorialListTableViewController: UITableViewController {

    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "使い方ガイド"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectColor()
        setColor()
        setCharacterSize()
    }
    
    func setColor() {
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            dismissButton.tintColor = UIColor.white
        } else {
            dismissButton.tintColor = UIColor(named: O_BLACK)
        }
    }
    
    func setCharacterSize() {
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 13)
            label2.font = UIFont.systemFont(ofSize: 13)
            label3.font = UIFont.systemFont(ofSize: 13)
            label4.font = UIFont.systemFont(ofSize: 13)
            label5.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label4.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            label5.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 15)
            label2.font = UIFont.systemFont(ofSize: 15)
            label3.font = UIFont.systemFont(ofSize: 15)
            label4.font = UIFont.systemFont(ofSize: 15)
            label5.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label4.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label5.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 17)
            label2.font = UIFont.systemFont(ofSize: 17)
            label3.font = UIFont.systemFont(ofSize: 17)
            label4.font = UIFont.systemFont(ofSize: 17)
            label5.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label4.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            label5.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 19)
            label2.font = UIFont.systemFont(ofSize: 19)
            label3.font = UIFont.systemFont(ofSize: 19)
            label4.font = UIFont.systemFont(ofSize: 19)
            label5.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            
            label1.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label2.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label3.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label4.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            label5.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if indexPath.row == 0 {
            let tutorial1VC = storyboard.instantiateViewController(withIdentifier: "Tutorial1VC")
            tutorial1VC.modalPresentationStyle = .automatic
            self.present(tutorial1VC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let tutorial2VC = storyboard.instantiateViewController(withIdentifier: "Tutorial2VC")
            tutorial2VC.modalPresentationStyle = .automatic
            self.present(tutorial2VC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let tutorial3VC = storyboard.instantiateViewController(withIdentifier: "Tutorial3VC")
            tutorial3VC.modalPresentationStyle = .automatic
            self.present(tutorial3VC, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let tutorial4VC = storyboard.instantiateViewController(withIdentifier: "Tutorial4VC")
            tutorial4VC.modalPresentationStyle = .automatic
            self.present(tutorial4VC, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            let tutorial5VC = storyboard.instantiateViewController(withIdentifier: "Tutorial5VC")
            tutorial5VC.modalPresentationStyle = .automatic
            self.present(tutorial5VC, animated: true, completion: nil)
        }
    }
}
