//
//  HistoryViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit
import RealmSwift

class HistoryViewController: UITableViewController {

    //MARK: - Variables
    var qrCodeDBManager = QRCodeDBManager()
    var qrcodes : Results<QRCode>?
    var qrResultType = QrResultTypes()

    //MARK: - viewSDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadQrCodes()
        self.tableView.rowHeight = 80.0

    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return qrcodes?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell", for: indexPath)
        cell.textLabel?.text = qrcodes?[indexPath.row].type ?? "No qr codes scanned yet"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 19.0)
        if qrcodes?[indexPath.row].type == qrCodeTypes.contactType {
            let contactNames = qrResultType.getContactName(result: (qrcodes?[indexPath.row].result)!)
            cell.detailTextLabel?.text = contactNames ?? "No qr codes scanned yet"
        }
        else {
        cell.detailTextLabel?.text = qrcodes?[indexPath.row].result ?? "No qr codes scanned yet"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        }

        return cell
    }
    
    //MARK: - Function that gets all the scanned QR codes from the database and loads them into the tableview
    
    func loadQrCodes() {
        qrcodes = qrCodeDBManager.getHistory()
        tableView.reloadData()
    }

}
