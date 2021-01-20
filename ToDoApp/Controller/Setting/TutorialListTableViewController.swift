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
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    @IBOutlet weak var arrow4: UIImageView!
    @IBOutlet weak var arrow5: UIImageView!
    @IBOutlet weak var arrow6: UIImageView!
    @IBOutlet weak var arrow7: UIImageView!
    
    lazy var labels = [label1,label2,label3,label4,label5,label6,label7]
    lazy var arrows = [arrow1,arrow2,arrow3,arrow4,arrow5,arrow6,arrow7]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "使い方ガイド"
        setSwipeBack()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectColor()
        setColor()
        setCharacterSize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let color: UIStatusBarStyle = defaults.object(forKey: WHITE_COLOR) != nil ? .darkContent : .lightContent
        return color
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setColor() {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : UIColor(named: O_BLACK)!
        let arrowColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .white : .systemGray3
        let tableViewColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK3)! : UIColor(named: O_WHITE)
        let separatorColor: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? .darkGray : .systemGray3
        
        tableView.separatorColor = separatorColor
        labels.forEach({$0?.textColor = color})
        arrows.forEach({$0?.tintColor = arrowColor})
        tableView.backgroundColor = tableViewColor
        
        if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            dismissButton.tintColor = UIColor(named: O_BLACK)
        } else if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            dismissButton.tintColor = .systemBlue
        } else {
            dismissButton.tintColor = .white
        }
    }
    
    func setCharacterSize() {
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13)})
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 13, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15)})
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 15, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17)})
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 17, weight: .medium)})
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19)})
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            labels.forEach({$0?.font = UIFont.systemFont(ofSize: 19, weight: .medium)})
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        if indexPath.row == 0 {
            let tutorial1VC = storyboard.instantiateViewController(withIdentifier: "Tutorial1VC")
            tutorial1VC.modalPresentationStyle = .automatic
            tutorial1VC.presentationController?.delegate = self
            self.present(tutorial1VC, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let tutorial2VC = storyboard.instantiateViewController(withIdentifier: "Tutorial2VC")
            tutorial2VC.presentationController?.delegate = self
            tutorial2VC.modalPresentationStyle = .automatic
            self.present(tutorial2VC, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let tutorial3VC = storyboard.instantiateViewController(withIdentifier: "Tutorial3VC")
            tutorial3VC.modalPresentationStyle = .automatic
            tutorial3VC.presentationController?.delegate = self
            self.present(tutorial3VC, animated: true, completion: nil)
        } else if indexPath.row == 3 {
            let tutorial4VC = storyboard.instantiateViewController(withIdentifier: "Tutorial4VC")
            tutorial4VC.modalPresentationStyle = .automatic
            tutorial4VC.presentationController?.delegate = self
            self.present(tutorial4VC, animated: true, completion: nil)
        } else if indexPath.row == 4 {
            let tutorial5VC = storyboard.instantiateViewController(withIdentifier: "Tutorial5VC")
            tutorial5VC.modalPresentationStyle = .automatic
            tutorial5VC.presentationController?.delegate = self
            self.present(tutorial5VC, animated: true, completion: nil)
        } else if indexPath.row == 5 {
            let tutorial6VC = storyboard.instantiateViewController(withIdentifier: "Tutorial6VC")
            tutorial6VC.modalPresentationStyle = .automatic
            tutorial6VC.presentationController?.delegate = self
            self.present(tutorial6VC, animated: true, completion: nil)
        } else {
            let tutorial7VC = storyboard.instantiateViewController(withIdentifier: "Tutorial7VC")
            tutorial7VC.modalPresentationStyle = .automatic
            tutorial7VC.presentationController?.delegate = self
            self.present(tutorial7VC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color: UIColor = UserDefaults.standard.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        cell.backgroundColor = color
    }
}

extension TutorialListTableViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}

extension TutorialListTableViewController: UIAdaptivePresentationControllerDelegate {
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    setNeedsStatusBarAppearanceUpdate()
    dispatchQ.asyncAfter(deadline: .now() + 0.6) {
        self.setNeedsStatusBarAppearanceUpdate()
    }
  }
}
