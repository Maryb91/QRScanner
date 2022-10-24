//
//  SettingsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: - Variables
    
    let items = ["About us","Contact us","Vibrate", "Terms of use","Privacy policy"]
    let icons = ["info.circle","envelope","iphone.radiowaves.left.and.right","doc.plaintext","lock.shield"]
    let vSwitch = UISwitch(frame: CGRect.zero) as UISwitch
    let userDefaults = UserDefaults.standard
    var qrType = QrResultTypes()

   //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.detailTextLabel?.text = ""
        cell.selectionStyle = .none
        let config = UIImage.SymbolConfiguration(pointSize: 23, weight: .light, scale: .default)
        cell.imageView?.image = UIImage(systemName: icons[indexPath.row],withConfiguration: config )?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        cell.textLabel?.font =  UIFont(name:"Mukta Mahee", size: 18.0)
        if(indexPath.row == 2){
            vSwitch.isOn = userDefaults.bool(forKey: "vibrate")
            vSwitch.addTarget(self, action: #selector(vibrateSwitch), for: .valueChanged)
            vSwitch.tag = indexPath.row
            cell.accessoryView = vSwitch
            cell.detailTextLabel?.text = "The phone vibrates when you scan a QR code"
            cell.detailTextLabel?.font = UIFont(name:"Mukta Mahee", size: 14.0)
        }

        return cell
    }
    
    
   //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 1)
        {
            openMailApp()
        }
       else if (indexPath.row == 2)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
            cell.selectionStyle = .none
        }
        else {
            performSegue(withIdentifier: "showSettingsDetails", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SettingsItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.labelTitle = items[indexPath.row]
        }
    }
    
    //MARK: - Turn On and Off the vibrations
    
    @objc func vibrateSwitch() {
        var vibrateStatus : Bool = false

        if vSwitch.isOn == true {  
            vibrateStatus = true
        }
        else {
            vibrateStatus = false
        }
       userDefaults.set(vibrateStatus, forKey: "vibrate")

    }
    
    //MARK: - Function to open the mail app (contact us)
    
    func openMailApp(){
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            let recipientEmail = "feedback.qrcodeapp@gmail.com"
                mail.setToRecipients([recipientEmail])
            let subject = "Feedback for QR code Reader app"
                mail.setSubject(subject)
            let body = ""
                mail.setMessageBody(body, isHTML: false)
            self.present(mail, animated: true, completion: nil)
        }
    }
    
    //MARK: - mailComposeController

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}
