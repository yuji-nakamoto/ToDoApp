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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        memoTextView.returnKeyType = .done
        
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13)
        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15)
        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17)
        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19)
        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            memoTextView.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
    
    func configureCell(_ templateMemo: TemplateMemo) {
        memoTextView.delegate = self
        memoTextView.text = templateMemo.name
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UserDefaults.standard.set(true, forKey: EDIT_TEMP)
        createTemplateVC?.viewDidAppear(true)
        editTemplateVC?.viewDidAppear(true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let realm = try! Realm()
        let templateMemos = realm.objects(TemplateMemo.self).filter("uid == '\(templateMemo.uid)'")
        
        templateMemos.forEach { (template) in
            try! realm.write() {
                template.name = memoTextView.text!
            }
        }
        createTemplateVC?.tableView.beginUpdates()
        createTemplateVC?.tableView.endUpdates()
        editTemplateVC?.tableView.beginUpdates()
        editTemplateVC?.tableView.endUpdates()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        TemplateMemo.deleteTemplateMemoUid(uid: templateMemo.uid) { [self] in
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            createTemplateVC?.viewWillAppear(true)
            editTemplateVC?.viewWillAppear(true)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            memoTextView.resignFirstResponder()
            UserDefaults.standard.removeObject(forKey: EDIT_TEMP)
            createTemplateVC?.viewWillAppear(true)
            editTemplateVC?.viewWillAppear(true)
            return false
        }
        return true
    }
}
