//
//  StartViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/28.
//

import UIKit
import RealmSwift

class StartViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
//        UserDefaults.standard.removeObject(forKey: SET_ITEM)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setItem()
    }

    private func setItem() {
        
        Item.fetchItem { [self] count in
            
            if count == itemArray.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    UserDefaults.standard.set(true, forKey: SET_ITEM)
                    toTabVC()
                }
            }
        }
    }
    
    private func toTabVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyboard.instantiateViewController(withIdentifier: "TabVC")
        self.present(tabVC, animated: true, completion: nil)
    }
}
