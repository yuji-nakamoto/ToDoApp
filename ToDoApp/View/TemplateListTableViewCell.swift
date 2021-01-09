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
   
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCheckMarkImageView))
        frontView.addGestureRecognizer(tap)
        
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            templateLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
    
    func configureCell(_ template: Template) {
        
        templateLabel.text = template.name
        let image = template.isSelect ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        checkMarkImageView.image = image
    }
    
    @objc func tapCheckMarkImageView() {
        
        let realm = try! Realm()
        let templeates = realm.objects(Template.self).filter("templateId == '\(template.templateId)'")
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
                    generator.notificationOccurred(.success)
                }
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
