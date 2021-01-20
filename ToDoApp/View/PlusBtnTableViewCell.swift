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
        let bgColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        backgroundColor = bgColor
        
        if defaults.object(forKey: GREEN_COLOR) != nil {
            plusButton.tintColor = UIColor(named: EMERALD_GREEN)
        } else if defaults.object(forKey: WHITE_COLOR) != nil {
            plusButton.tintColor = UIColor.systemBlue
        } else if defaults.object(forKey: PINK_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_PINK)
        } else if defaults.object(forKey: ORANGE_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_ORANGE)
        } else {
            plusButton.tintColor = UIColor.systemBlue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        let bgColor: UIColor = defaults.object(forKey: DARK_COLOR) != nil ? UIColor(named: O_DARK1)! : .systemBackground
        backgroundColor = bgColor
        
        if defaults.object(forKey: GREEN_COLOR) != nil {
            plusButton.tintColor = UIColor(named: EMERALD_GREEN)
        } else if defaults.object(forKey: WHITE_COLOR) != nil {
            plusButton.tintColor = UIColor.systemBlue
        } else if defaults.object(forKey: PINK_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_PINK)
        } else if defaults.object(forKey: ORANGE_COLOR) != nil {
            plusButton.tintColor = UIColor(named: O_ORANGE)
        } else {
            plusButton.tintColor = UIColor.systemBlue
        }
    }
}
