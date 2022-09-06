//
//  DetailsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 23/8/2022.
//

import UIKit
import RealmSwift
import AVFoundation
import ContactsUI
import MessageUI

class DetailsViewController: UIViewController,CNContactViewControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    //MARK: - Variables
    
    var qrCode = QRCode()
    var qrCodeDBManager = QRCodeDBManager()
    var session = AVCaptureSession()
    var qrResultType = QrResultTypes()
    var pc = PermissionChecker()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        qrCode = qrCodeDBManager.getQRCode()!
        showScannedQRCode()
    }
    
    //MARK: - Getting the scanned QR code and displaying its details
    
    func showScannedQRCode() {
        qrCode = qrCodeDBManager.getQRCode()!
        typeLabel.text = qrCode.type
        dateLabel.text = qrCode.date
        resultTextView.text = qrCode.result
        actionButton.setTitle(qrResultType.actionTitle(scanResultType: qrCode.type), for: .normal)
        if(qrCode.type == qrCodeTypes.textType)
        {
            secondButton.isHidden = false
        }
        if (qrCode.type == qrCodeTypes.contactType || qrCode.type == qrCodeTypes.emailType)
        {
            actionButton.setTitle(qrResultType.actionTitle(scanResultType: qrCode.type), for: .normal)
            resultTextView.isHidden = true
            view.addConstraints([
                NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: actionButton, attribute: .centerX, multiplier: 1.0, constant: 0.0),
                NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: actionButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            ])
            print(qrCode.result)
        }
        if(qrCode.type == qrCodeTypes.phoneType)
        {
            secondButton.isHidden = false
            secondButton.setTitle("Copy", for: .normal)
        }
    }
    
    
    //MARK: - Action button pressed function (depending on the type of the QR Code scanned)
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        qrResultType.actionToType(qrcode: qrCode, vc:self)
        
    }
    
    //MARK: - Search the QR code scan result in Google
    
    @IBAction func secondButtonPressed(_ sender: UIButton) {
        
        if(qrCode.type == qrCodeTypes.phoneType)
        {
            qrResultType.copyText(scanResult:qrCode.result)
        }
        else {
            qrResultType.searchOnGoogle(result: qrCode.result)
        }
    }
    
    
    //MARK: - Share button pressed function
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let text = qrCode.result
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - Actions to perform depending on the Contacts permission status
    
    func authorizedPermission () -> Void{
        if let data = qrCode.result.data(using: .utf8) {
            do{
                let contacts = try CNContactVCardSerialization.contacts(with: data)
                let newContact = contacts.first!
                let contactVC = CNContactViewController(forUnknownContact: newContact)
                contactVC.contactStore = CNContactStore()
                contactVC.delegate = self
                contactVC.allowsActions = false
                contactVC.addDissmissButton()
                let navigationController = UINavigationController(rootViewController: contactVC)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: false)
            }catch {
                print("error")
            }
        }
    }
    
    func deniedPermission() -> Void{
        let settingsAlert = UIAlertController(title: "Allow permission", message: "Please allow the Contacts permission from the app settings to show the scanned contact details", preferredStyle: UIAlertController.Style.alert)
        settingsAlert.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { (action: UIAlertAction!) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        settingsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            settingsAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(settingsAlert, animated: true, completion: nil)
    }
    
    
    //MARK: - mailComposeController
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


    //MARK: - Actions to perform when the DetailsVC is dismissed
    
    override func viewDidDisappear(_ animated: Bool)
    {
        session.startRunning()
    }
    
}
//MARK: - Adding a button to dismiss the contactVC

extension UIBarButtonItem {
private struct AssociatedObject {
    static var key = "action_closure_key"
}

var actionClosure: (()->Void)? {
    get {
        return objc_getAssociatedObject(self, &AssociatedObject.key) as? ()->Void
    }
    set {
        objc_setAssociatedObject(self, &AssociatedObject.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        target = self
        action = #selector(didTapButton(sender:))
    }
}

@objc func didTapButton(sender: Any) {
    actionClosure?()
}
}

extension UIViewController{
func addDissmissButton(){
    let cancelButton = UIBarButtonItem.init(title: "©", style: .plain, target: self, action: nil)
    cancelButton.actionClosure = {
        self.dismiss(animated: true)
    }
    self.navigationItem.leftBarButtonItem = cancelButton
}}
