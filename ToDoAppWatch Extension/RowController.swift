//
//  RowController.swift
//  ToDoAppWatch Extension
//
//  Created by yuji nakamoto on 2020/12/08.
//

import Foundation
import WatchKit
import WatchConnectivity

class RowController: NSObject {
    
    @IBOutlet weak var checkBtn: WKInterfaceButton!
    @IBOutlet weak var rowLabel: WKInterfaceLabel!
    
    var data = String()
    var tap = false
    
    @IBAction func tapBtn() {
        if tap {
            checkBtn.setBackgroundImage(UIImage(named: "square"))
            rowLabel.setTextColor(UIColor.white)
            tap = false
            guard WCSession.isSupported() else { return }
            do {
                try WCSession.default.updateApplicationContext(["WatchTableData" : data + ": false"])
            }
            catch {
                print(error.localizedDescription)
            }
        } else {
            checkBtn.setBackgroundImage(UIImage(named: "square.slash"))
            rowLabel.setTextColor(UIColor.darkGray)
            tap = true
            guard WCSession.isSupported() else { return }
            do {
                try WCSession.default.updateApplicationContext(["WatchTableData" : data])
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}
