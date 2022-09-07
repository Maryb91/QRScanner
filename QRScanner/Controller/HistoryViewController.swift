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
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scanButton: UIButton!
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadQrCodes()
        self.tableView.rowHeight = 80.0
        scanButton.isHidden = true
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(qrcodes!.count >= 1)
        {
            return qrcodes!.count
        }
        else{
            scanButton.isHidden = false
            scanButton.setTitle("Scan QR codes Now", for: .normal)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell", for: indexPath)
        cell.textLabel?.text = qrcodes?[indexPath.row].type
        cell.textLabel?.font = UIFont.systemFont(ofSize: 19.0)
        if qrcodes?[indexPath.row].type == qrCodeTypes.contactType {
            let contactNames = qrResultType.getContactName(result: (qrcodes?[indexPath.row].result)!)
            cell.detailTextLabel?.text = contactNames
        }
        else {
        cell.detailTextLabel?.text = qrcodes?[indexPath.row].result 
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        }

        return cell
    }
    
    //MARK: - Function that gets all the scanned QR codes from the database and loads them into the tableview
    
    func loadQrCodes() {
        qrcodes = qrCodeDBManager.getHistory()
        tableView.reloadData()
    }
    
    //MARK: - Scan function when the Scan button is Pressed
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarController
        self.present(newViewController, animated: true, completion: nil)
    }
    

}
