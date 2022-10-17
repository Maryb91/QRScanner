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
    let cellSpacingHeight: CGFloat = 0
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        loadQrCodes()
    }
    
   
    //MARK: - viewDidLoad

    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
    
      //  scanButton.isHidden = true
    }
    
    
    //MARK: - TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {

        if(qrcodes!.count >= 1)
        {
            return qrcodes!.count
        }
        else{
//            scanButton.isHidden = false
//            scanButton.setTitle("Scan QR codes Now", for: .normal)
            return 0
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var config : UIImage.SymbolConfiguration
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell", for: indexPath)
         
        cell.layer.cornerRadius = 8
        
         if (qrcodes?[indexPath.section].type == qrCodeTypes.contactType || qrcodes?[indexPath.section].type == qrCodeTypes.emailType){
          config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light, scale: .default)
         }
         else {
              config = UIImage.SymbolConfiguration(pointSize: 28, weight: .light, scale: .default)
         }
         
         cell.textLabel?.text = qrcodes?[indexPath.section].type
         cell.imageView?.image = UIImage(systemName: getIcon(type: (qrcodes?[indexPath.section].type)!),withConfiguration: config )?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)

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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return cellSpacingHeight
      }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
       }

    //MARK: - Function that gets all the scanned QR codes from the database and loads them into the tableview
    
    func loadQrCodes() {
        qrcodes = qrCodeDBManager.getHistory()
        tableView.reloadData()
        showClearAllButton()
    }
    
    //MARK: - Scan function when the Scan button is Pressed
    
    @IBAction func clearAll(_ sender: UIBarButtonItem) {
                let clearAllAlert = UIAlertController(title: "Clear History", message: "Are you sure you want to delete all the QR codes in history?", preferredStyle: UIAlertController.Style.alert)
                clearAllAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.qrCodeDBManager.deleteAll()
                    self.tableView.reloadData()
                    self.showClearAllButton()
                }))
                clearAllAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    clearAllAlert.dismiss(animated: true, completion: nil)
                }))
                self.present(clearAllAlert, animated: true, completion: nil)
    }
    
    //    @IBAction func scanButtonPressed(_ sender: UIButton) {
//        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarViewController
//        self.present(newViewController, animated: true, completion: nil)
//    }
//
    //MARK: - Passing the parameteres to DetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! DetailsViewController
    }

    
    //MARK: - Icon depending on the QR code scanned
    
    func getIcon(type : String) -> String
    {
        var iconImage = ""
        if(type==qrCodeTypes.phoneType)
        {
            iconImage = "phone.fill"
        }
        else if (type==qrCodeTypes.textType)
        {
            iconImage = "t.square.fill"
        }
        else if (type==qrCodeTypes.emailType)
        {
           iconImage = "envelope.fill"
        }
        else if (type==qrCodeTypes.websiteType)
        {
            iconImage = "link.circle.fill"
        }
        else if (type==qrCodeTypes.contactType)
        {
            iconImage = "person.text.rectangle.fill"
        }
        return iconImage
    }
    
    //MARK: - Show/Hide Clear all navigation item
    
    func showClearAllButton()
    {   qrcodes = qrCodeDBManager.getHistory()
        print(qrcodes?.count)
        if((qrcodes?.count)! == 0)
        {
           self.clearAllButton.isEnabled = false
           self.clearAllButton.tintColor = .clear
        }
        else {
            self.clearAllButton.isEnabled = true
            self.clearAllButton.tintColor = .systemIndigo
        }
    }
}
