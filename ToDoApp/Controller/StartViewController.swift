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
    private var date = Date()
    private let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.startAnimating()
        UserDefaults.standard.set(true, forKey: GREEN_COLOR)
        UserDefaults.standard.set(true, forKey: ON_INPUT)
        UserDefaults.standard.set(true, forKey: ON_PUSH)
        let twoWeek =  calendar.date(byAdding: .day, value: 14, to: date)
        UserDefaults.standard.set(twoWeek, forKey: REVIEW)
        UserDefaults.standard.set(true, forKey: MIDIUM2)
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
