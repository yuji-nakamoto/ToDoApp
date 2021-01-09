//
//  DetailInterfaceController.swift
//  ToDoAppWatch Extension
//
//  Created by yuji nakamoto on 2020/12/09.
//

import Foundation
import WatchKit

class DetailInterfaceController: InterfaceController {
    
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let detailData = context as? String {
            detailLabel.setText(detailData)
        }
    }
}
