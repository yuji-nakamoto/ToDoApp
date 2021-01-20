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
        if let tableData = applicationContext["WatchTableData"] as? [String],
           let tableData2 = applicationContext["WatchTableData2"] as? [Bool] {
            tableView.setNumberOfRows(tableData.count, withRowType: "RowController")
            tableView.setNumberOfRows(tableData2.count, withRowType: "RowController")
            
            self.tableData = tableData
            let bool = tableData == [] ? false : true
            nodataLabel.setHidden(bool)
            descriptionLabel.setHidden(bool)
            
            for (index, rowModel) in tableData.enumerated() {
                if let rowController = tableView.rowController(at: index) as? RowController {
                    rowController.rowLabel.setText(rowModel)
                    rowController.data = rowModel
                }
            }
            for (index, rowModel) in tableData2.enumerated() {
                if let rowController = tableView.rowController(at: index) as? RowController {
                    let setBtnImage: UIImage = rowModel ? UIImage(named: "square.slash")! : UIImage(named: "square")!
                    let color: UIColor = rowModel ? .darkGray : .white
                    let bool = rowModel ? true : false
                    rowController.checkBtn.setBackgroundImage(setBtnImage)
                    rowController.rowLabel.setTextColor(color)
                    rowController.tap = bool
                }
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(error?.localizedDescription as Any)
    }
}
