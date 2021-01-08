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
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    
    var historyVC: HistoryTableViewController?
    var history = History()
    
    func configureCell(_ history: History) {
        itemNameLabel.text = "\(history.name)は"
        let date = Date(timeIntervalSince1970: history.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = "\(dateString)、"
        timestampLabel.text = history.timestamp
    }
    
    func configureTempCell(_ TempMemo: TemplateMemo) {
        itemNameLabel.text = "\(TempMemo.name)は"
        let date = Date(timeIntervalSince1970: TempMemo.date)
        let dateString = timeAgoSinceDate(date, currentDate: Date(), numericDates: true)
        dateLabel.text = "\(dateString)、"
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let realm = try! Realm()
        let histories = realm.objects(History.self).filter("uid == '\(history.uid)'")
        
        try! realm.write() {
            realm.delete(histories)
            historyVC?.viewWillAppear(true)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13)
            dateLabel.font = UIFont.systemFont(ofSize: 13)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 13)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 13)

        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)

        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15)
            dateLabel.font = UIFont.systemFont(ofSize: 15)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 15)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 15)

        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17)
            dateLabel.font = UIFont.systemFont(ofSize: 17)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 17)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 17)

        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19)
            dateLabel.font = UIFont.systemFont(ofSize: 19)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 19)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 19)

        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            if timestampLabel != nil {
                timestampLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            }
            cartLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: SMALL1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13)
            dateLabel.font = UIFont.systemFont(ofSize: 13)
            timestampLabel.font = UIFont.systemFont(ofSize: 13)
            cartLabel.font = UIFont.systemFont(ofSize: 13)

        } else if UserDefaults.standard.object(forKey: SMALL2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            timestampLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
            cartLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)

        } else if UserDefaults.standard.object(forKey: MIDIUM1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15)
            dateLabel.font = UIFont.systemFont(ofSize: 15)
            timestampLabel.font = UIFont.systemFont(ofSize: 15)
            cartLabel.font = UIFont.systemFont(ofSize: 15)

        } else if UserDefaults.standard.object(forKey: MIDIUM2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            timestampLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            cartLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        } else if UserDefaults.standard.object(forKey: MIDIUM3) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17)
            dateLabel.font = UIFont.systemFont(ofSize: 17)
            timestampLabel.font = UIFont.systemFont(ofSize: 17)
            cartLabel.font = UIFont.systemFont(ofSize: 17)

        } else if UserDefaults.standard.object(forKey: MIDIUM4) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            timestampLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            cartLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)

        } else if UserDefaults.standard.object(forKey: BIG1) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19)
            dateLabel.font = UIFont.systemFont(ofSize: 19)
            timestampLabel.font = UIFont.systemFont(ofSize: 19)
            cartLabel.font = UIFont.systemFont(ofSize: 19)

        } else if UserDefaults.standard.object(forKey: BIG2) != nil {
            itemNameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            dateLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            timestampLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
            cartLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        }
    }
}
