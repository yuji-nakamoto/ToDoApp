//
//  InterfaceController.swift
//  ToDoAppWatch Extension
//
//  Created by yuji nakamoto on 2020/12/08.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    @IBOutlet weak var nodataLabel: WKInterfaceLabel!
    @IBOutlet weak var descriptionLabel: WKInterfaceLabel!
    
    var session = WCSession.default
    var tableData = [String]()
    
    override func willActivate() {
        super.willActivate()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "DetailIC", context: tableData[rowIndex])
    }
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print(applicationContext)
        if let tableData = applicationContext["WatchTableData"] as? [String] {
            tableView.setNumberOfRows(tableData.count, withRowType: "RowController")
            self.tableData = tableData
            if tableData == [] {
                nodataLabel.setHidden(false)
                descriptionLabel.setHidden(false)
            } else {
                nodataLabel.setHidden(true)
                descriptionLabel.setHidden(true)
            }
            for (index, rowModel) in tableData.enumerated() {
                if let rowController = tableView.rowController(at: index) as? RowController {
                    rowController.rowLabel.setText(rowModel)
                    rowController.data = rowModel
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
