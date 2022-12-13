//
//  HistoryViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//
import UIKit
import RealmSwift
import SwipeCellKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate{
   
    
    //MARK: - Variables
    
    var qrCodeDBManager = QRCodeDBManager()
    var qrcodes : Results<QRCode>?
    var qrResultType = QrResultTypes()
    var qrCodeResult = QrCodeResult()
    var selectedQRCode : QRCode?
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var clearAllButton: UIBarButtonItem!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scdView: UIView!
    
    //MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        scdView.isHidden = true
        loadQrCodes()
    }
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    //MARK: - TableView Datasource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {

           if(qrcodes!.count >= 1)
           {
               return qrcodes!.count
           }
           else
           {
               return 0
           }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var config : UIImage.SymbolConfiguration
        let cell = tableView.dequeueReusableCell(withIdentifier: "qrCell") as! SwipeTableViewCell
        cell.delegate = self
        cell.layer.cornerRadius = 15
        cell.layer.borderColor = UIColor.systemGray6.cgColor
        cell.layer.borderWidth = 5
        
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQRCode = qrcodes?[indexPath.section]
        self.performSegue(withIdentifier: "showDetails", sender: self)

        
    }
    
    //MARK: - Delete a Row
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive,title: "Trash") { action, indexPath in
                    if let qrcode = self.qrcodes?[indexPath.section] {
                        self.qrCodeDBManager.deleteHistoryItem(qrcode: qrcode)
                        let indexSet = IndexSet(arrayLiteral: indexPath.section)
                        tableView.deleteSections(indexSet, with:.fade)
                        self.loadQrCodes()
                    }
            }
        deleteAction.image = UIImage(systemName:"trash.circle.fill")?.resized(to: CGSize(width: 45.0, height: 45.0))?.withTintColor(UIColor.systemRed)
        deleteAction.textColor = UIColor.systemRed
        deleteAction.backgroundColor = UIColor.systemGray6
            return [deleteAction]
    }
    
    
    //MARK: - Swipe options
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .none
        options.backgroundColor = UIColor.systemGray6
        options.transitionStyle = .reveal
          return options
    }
    

    
    //MARK: - Function that gets all the scanned QR codes from the database and loads them into the tableview
    
    func loadQrCodes() {
        qrcodes = qrCodeDBManager.getHistory()
        tableView.reloadData()
        if(qrcodes?.count == 0)
        {
            self.clearAllButton.isEnabled = false
            self.clearAllButton.tintColor = .clear
            self.tableView.addSubview(scdView)
            scdView.isHidden = false
            scanButton.translatesAutoresizingMaskIntoConstraints = false
            scanButton.layer.masksToBounds = true
            scanButton.layer.borderColor = UIColor.white.cgColor
            scanButton.layer.borderWidth = 6
            scanButton.layer.cornerRadius = 85





        }
        else {
            tableView.reloadData()
            self.clearAllButton.isEnabled = true
            self.clearAllButton.tintColor = .systemIndigo
            self.clearAllButton.setTitleTextAttributes([.font : UIFont.systemFont(ofSize: 18, weight: .regular), .foregroundColor : UIColor.systemIndigo], for: .normal)
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
        let destinationVC = segue.destination as! DetailsViewController
        destinationVC.qrCode = selectedQRCode
    }
    
    
    //MARK: - Scan button pressed (Empty History)
    
    
    @IBAction func scanAction(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
}

//MARK: - Resizing a UIImage

extension UIImage {
  func resized(to newSize: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
    defer { UIGraphicsEndImageContext() }

    draw(in: CGRect(origin: .zero, size: newSize))
    return UIGraphicsGetImageFromCurrentImageContext()
  }
}
