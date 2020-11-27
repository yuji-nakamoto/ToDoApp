//
//  TemplateMemoTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import RealmSwift

class TemplateMemoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var memoTextField: UITextField!
    
    var createTemplateVC: CreateTemplateViewController?
    var editTemplateVC: EditTemplateViewController?
    var templateMemo = TemplateMemo()
    
    func configureCell(_ templateMemo: TemplateMemo) {
        memoTextField.delegate = self
        memoTextField.text = templateMemo.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memoTextField.returnKeyType = .done
        memoTextField.addTarget(self, action: #selector(textFieldBeginEditing), for: .editingDidBegin)
    }
    
    @objc func textFieldBeginEditing() {
        UserDefaults.standard.set(true, forKey: "edit")
        createTemplateVC?.viewDidAppear(true)
        editTemplateVC?.viewDidAppear(true)
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(templateMemo.uid)'")
        
        try! realm.write() {
            realm.delete(templateMemos)
            UserDefaults.standard.removeObject(forKey: "edit")
            createTemplateVC?.viewWillAppear(true)
            editTemplateVC?.viewWillAppear(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if memoTextField.text == "" { return false }
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(templateMemo.uid)'")
        
        templateMemos.forEach { (template) in
            try! realm.write() {
                template.name = memoTextField.text!
            }
        }
        memoTextField.resignFirstResponder()
        UserDefaults.standard.removeObject(forKey: "edit")
        UserDefaults.standard.removeObject(forKey: "plus")
        createTemplateVC?.viewWillAppear(true)
        editTemplateVC?.viewWillAppear(true)
        return true
    }
}
