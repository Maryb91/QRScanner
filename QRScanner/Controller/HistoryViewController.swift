//
//  HistoryViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//
import UIKit
import RealmSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Variables
    
    var qrCodeDBManager = QRCodeDBManager()
    var qrcodes : Results<QRCode>?
    var qrResultType = QrResultTypes()
    var qrCodeResult = QrCodeResult()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scdView: UIView!
    @IBOutlet weak var scanButton: UIImageView!
    
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        scdView.isHidden = true
        loadQrCodes()
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.scanAction))
               scanButton.addGestureRecognizer(tap)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: - TableView Datasource Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(qrcodes!.count >= 1)
        {
            return qrcodes!.count
        }
        else
        {
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var config : UIImage.SymbolConfiguration
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell", for: indexPath)
        
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 7
        
        if (qrcodes?[indexPath.section].type == qrCodeTypes.contactType || qrcodes?[indexPath.section].type == qrCodeTypes.emailType){
            config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
        }
        else {
            config = UIImage.SymbolConfiguration(pointSize: 28, weight: .light, scale: .default)
        }
        
        cell.textLabel?.text = qrcodes?[indexPath.section].type
        cell.imageView?.image = UIImage(systemName: qrResultType.getIcon(type: (qrcodes?[indexPath.section].type)!),withConfiguration: config )?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        
        if qrcodes?[indexPath.section].type == qrCodeTypes.contactType {
            let contactNames = qrResultType.getContactName(result: (qrcodes?[indexPath.section].result)!)
            cell.detailTextLabel?.text = contactNames
        }
        else {
            cell.detailTextLabel?.text = qrcodes![indexPath.section].result
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let qrcode = qrcodes?[indexPath.section] {
                qrCodeDBManager.deleteHistoryItem(qrcode: qrcode)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(indexSet, with:.fade)
                loadQrCodes()
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.qrCodeResult.getQrCodeResult(qrCodeString: (qrcodes?[indexPath.section].result)!,picker: nil,vc: self, qrCodeScanSource: "")
    }
    
    
    //MARK: - Function that gets all the scanned QR codes from the database and loads them into the tableview
    
    func loadQrCodes() {
        qrcodes = qrCodeDBManager.getHistory()
        if(qrcodes?.count == 0)
        {
            self.clearAllButton.isEnabled = false
            self.clearAllButton.tintColor = .clear
            self.tableView.addSubview(scdView)
            scdView.isHidden = false
        }
        else {
            self.clearAllButton.isEnabled = true
            self.clearAllButton.tintColor = .systemIndigo
            tableView.reloadData()
        }
    }
    
    //MARK: - Scan function when the Scan button is Pressed
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
        let clearAllAlert = UIAlertController(title: "Clear History", message: "Are you sure you want to delete all the QR codes in history?", preferredStyle: UIAlertController.Style.alert)
        clearAllAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.qrCodeDBManager.deleteAll()
            self.tableView.reloadData()
            self.loadQrCodes()
            
        }))
        clearAllAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            clearAllAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(clearAllAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - Passing the parameteres to DetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! DetailsViewController
    }
    
    
    //MARK: - Scan button pressed (Empty History)
    
    @objc func scanAction(){
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
   
    
    
    

    
    
    
    
    
    
    
}
