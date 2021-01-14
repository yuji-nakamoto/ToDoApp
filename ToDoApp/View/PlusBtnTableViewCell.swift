//
//  PlusBtnTableViewCell.swift
//  ToDoApp
//
//  Created by yuji nakamoto on 2021/01/13.
//

import UIKit

class PlusBtnTableViewCell: UITableViewCell {
    
    @IBOutlet weak var plusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            plusButton.tintColor = UIColor(named: EMERALD_GREEN)
            backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            plusButton.tintColor = UIColor.systemBlue
            backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_PINK)
            backgroundColor = .systemBackground
        } else {
            plusButton.tintColor = UIColor.systemBlue
            backgroundColor = UIColor(named: O_DARK1)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if UserDefaults.standard.object(forKey: GREEN_COLOR) != nil {
            plusButton.tintColor = UIColor(named: EMERALD_GREEN)
            backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: WHITE_COLOR) != nil {
            plusButton.tintColor = UIColor.systemBlue
            backgroundColor = .systemBackground
        } else if UserDefaults.standard.object(forKey: PINK_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_PINK)
            backgroundColor = .systemBackground
        } else {
            plusButton.tintColor = UIColor.systemBlue
            backgroundColor = UIColor(named: O_DARK1)
        }
    }
}
