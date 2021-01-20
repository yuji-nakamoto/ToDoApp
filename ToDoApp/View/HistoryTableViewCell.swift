//
//  HistoryTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2020/11/30.
//

import UIKit
import RealmSwift

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    
    lazy var labels = [itemNameLabel,dateLabel,cartLabel]
    var historyVC: HistoryTableViewController?
    var history = History()
    
    func configureCell(_ history: History) {
        itemNameLabel.text = "\(history.name)は"
        let date = Date(timeIntervalSince1970: history.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = "\(dateString)、"
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            dateLabel.textColor = UIColor(named: EMERALD_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            dateLabel.textColor = UIColor.systemBlue
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            dateLabel.textColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
            dateLabel.textColor = UIColor(named: O_ORANGE)
        } else {
            dateLabel.textColor = UIColor.systemBlue
        }
    }
    
    func configureTempCell(_ TempMemo: TemplateMemo) {
        itemNameLabel.text = "\(TempMemo.name)は"
        let date = Date(timeIntervalSince1970: TempMemo.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = "\(dateString)、"
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            dateLabel.textColor = UIColor(named: EMERALD_GREEN)
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            dateLabel.textColor = UIColor.systemBlue
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            dateLabel.textColor = UIColor(named: O_PINK)
        } else if UserDefaults.standard.object(forKey: ORANGE_COLOR) != nil {
            dateLabel.textColor = UIColor(named: O_ORANGE)
        } else {
            dateLabel.textColor = UIColor.systemBlue
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let realm = try! Realm()
        let histories = realm.objects(History.self).filter("uid == '\(history.uid)'").filter("timestamp == '\(history.timestamp)'")
        
        try! realm.write() {
            realm.delete(histories)
            historyVC?.viewWillAppear(true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            itemNameLabel.textColor = .white
            cartLabel.textColor = .white
        } else {
            backgroundColor = .systemBackground
            itemNameLabel.textColor = UIColor(named: O_BLACK)
            cartLabel.textColor = UIColor(named: O_BLACK)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
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
        
        if UserDefaults.standard.object(forKey: DARK_COLOR) != nil {
            backgroundColor = UIColor(named: O_DARK1)
            itemNameLabel.textColor = .white
            cartLabel.textColor = .white
        } else {
            backgroundColor = .systemBackground
            itemNameLabel.textColor = UIColor(named: O_BLACK)
            cartLabel.textColor = UIColor(named: O_BLACK)
        }
    }
}
