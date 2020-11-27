//
//  VersionTableViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/27.
//

import UIKit

class VersionTableViewController: UITableViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSwipeBack()
        navigationItem.title = "バージョンについて"
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
