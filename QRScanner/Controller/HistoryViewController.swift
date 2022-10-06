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
    var qrCodeResult = QrCodeResult()

    
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
            cell.detailTextLabel?.text = qrcodes![indexPath.row].result
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15.0)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let qrcode = qrcodes?[indexPath.row] {
                qrCodeDBManager.deleteHistoryItem(qrcode: qrcode)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.qrCodeResult.getQrCodeResult(qrCodeString: (qrcodes?[indexPath.row].result)!,picker: nil,vc: self, qrCodeScanSource: "")
        
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
    
    //MARK: - Passing the parameteres to DetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! DetailsViewController
    }
    
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        let clearAllAlert = UIAlertController(title: "Clear the History", message: "Are you sure you want to clear all the QR codes in history?", preferredStyle: UIAlertController.Style.alert)
        clearAllAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.qrCodeDBManager.deleteAll()
            self.tableView.reloadData()
        }))
        clearAllAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            clearAllAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(clearAllAlert, animated: true, completion: nil)

}
}
