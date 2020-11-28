//
//  TemplateListTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import RealmSwift

class TemplateListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var templateLabel: UILabel!
    @IBOutlet weak var frontView: UIView!
    
    var templateListVC: TemplateListViewController?
    var template = Template()
    
    func configureCell(_ template: Template) {
        
        templateLabel.text = template.name
        if template.isSelect == true {
            checkMarkImageView.image = UIImage(systemName: "checkmark.square")
        } else {
            checkMarkImageView.image = UIImage(systemName: "square")
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCheckMarkImageView))
        frontView.addGestureRecognizer(tap)
    }
    
    @objc func tapCheckMarkImageView() {
        
        let realm = try! Realm()
        let templeates = realm.objects(Template.self).filter("id == '\(template.id)'")
        let allTempleates = realm.objects(Template.self)
        
        allTempleates.forEach { (allTemplate) in
            try! realm.write() {
                allTemplate.isSelect = false
            }
        }
        
        templeates.forEach { (template) in
            
            if checkMarkImageView.image == UIImage(systemName: "square") {
                try! realm.write() {
                    template.isSelect = true
                    checkMarkImageView.image = UIImage(systemName: "checkmark.square")
                    if UserDefaults.standard.object(forKey: ON_CHECK) != nil {
                        generator.notificationOccurred(.success)
                    }                }
            } else {
                try! realm.write() {
                    template.isSelect = false
                    checkMarkImageView.image = UIImage(systemName: "square")
                }
            }
            templateListVC?.viewWillAppear(true)
        }
    }
}
