//
//  TemplateListViewController.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class TemplateListViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    private var templates = [Template]()
    private var id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10000
        navigationItem.title = "ひな形"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTemplate()
        UserDefaults.standard.removeObject(forKey: CLOSE)
    }
    
    private func fetchTemplate() {
        
        let realm = try! Realm()
        let templateArray = realm.objects(Template.self)
        
        templates.removeAll()
        templates.append(contentsOf: templateArray)
        
        templateArray.forEach { (t) in
            try! realm.write() {
                t.selected = false
            }
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EditTemplateVC" {
            let editTemplateVC = segue.destination as! EditTemplateViewController
            editTemplateVC.id = id
        }
    }
    
    private func setupBanner() {
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension TemplateListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 1 + templates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCell(withIdentifier: "Cell1")
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "Cell2")
        let cell3 = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! TemplateListTableViewCell
        
        if indexPath.row == 0 {
            return cell1!
        } else if indexPath.row == 1 {
            return cell2!
        }
        
        cell3.templateListVC = self
        cell3.template = templates[indexPath.row - 2]
        cell3.configureCell(templates[indexPath.row - 2])
        return cell3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row >= 2 {
            id = templates[indexPath.row - 2].id
            performSegue(withIdentifier: "EditTemplateVC", sender: nil)
        }
    }
}
