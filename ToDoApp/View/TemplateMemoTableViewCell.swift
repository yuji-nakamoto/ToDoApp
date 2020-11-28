//
//  TemplateMemoTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/26.
//

import UIKit
import RealmSwift

class TemplateMemoTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var memoTextView: UITextView!
    
    var createTemplateVC: CreateTemplateViewController?
    var editTemplateVC: EditTemplateViewController?
    var templateMemo = TemplateMemo()
    
    func configureCell(_ templateMemo: TemplateMemo) {
        memoTextView.delegate = self
        memoTextView.text = templateMemo.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memoTextView.returnKeyType = .done
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UserDefaults.standard.set(true, forKey: EDIT_TEMP)
        createTemplateVC?.viewDidAppear(true)
        editTemplateVC?.viewDidAppear(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        createTemplateVC?.tableView.beginUpdates()
        createTemplateVC?.tableView.endUpdates()
        editTemplateVC?.tableView.beginUpdates()
        editTemplateVC?.tableView.endUpdates()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(templateMemo.uid)'")
        
        try! realm.write() {
            realm.delete(templateMemos)
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            createTemplateVC?.viewWillAppear(true)
            editTemplateVC?.viewWillAppear(true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if memoTextView.text == "" { return false }
        
        if text == "\n" {
            let realm = try! Realm()
            let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(templateMemo.uid)'")
            
            templateMemos.forEach { (template) in
                try! realm.write() {
                    template.name = memoTextView.text!
                }
            }
            memoTextView.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            UserDefaults.standard.removeObject(forKey: CLOSE)
            createTemplateVC?.viewWillAppear(true)
            editTemplateVC?.viewWillAppear(true)
            return false
        }
        return true
    }
}
