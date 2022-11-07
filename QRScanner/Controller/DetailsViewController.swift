//
//  DetailsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 23/8/2022.
//

import UIKit
import AVFoundation
import ContactsUI
import MessageUI

class DetailsViewController: UIViewController,CNContactViewControllerDelegate, UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    //MARK: - Variables
    
    var qrCode : QRCode?
    var qrCodeDBManager = QRCodeDBManager()
    var session = AVCaptureSession()
    var qrResultType = QrResultTypes()
    var pc = PermissionChecker()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var actionView: UIView!
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScannedQRCode()
    }
    
    //MARK: - Getting the scanned QR code and displaying its details
    
    func showScannedQRCode() {
        
        //SearchButton Layout
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = UIColor.systemIndigo.cgColor
        searchButton.layer.cornerRadius = 8
        
        //ActionButton Layout
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.systemIndigo.cgColor
        actionButton.layer.cornerRadius = 8
        actionButton.setImage(UIImage(systemName: qrResultType.actionIcon(type: qrCode!.type)), for: .normal)
        actionButton.setTitle(qrResultType.actionTitle(scanResultType: qrCode!.type), for: .normal)

        //ShareButton Layout
        shareButton.layer.cornerRadius = 8
        
        iconImage.image = UIImage(systemName:qrResultType.getIcon(type: qrCode!.type))?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        
        //FirstView Layout
        firstView.layer.cornerRadius = 15
        firstView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        //LastView Layout
        lastView.layer.cornerRadius = 15
        lastView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] // Top right corner, Top left corner respectively

        typeLabel.text = qrCode?.type
        dateLabel.text = qrCode?.date
        resultTextView.text = qrCode?.result
        
        if (qrCode?.type == qrCodeTypes.phoneType || qrCode?.type == qrCodeTypes.websiteType || qrCode?.type == qrCodeTypes.contactType || qrCode?.type == qrCodeTypes.emailType)
        {
            searchButton.isHidden = true
            lastView.backgroundColor = UIColor.systemGray6
            actionView.layer.cornerRadius = 15
            actionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        }

    }
    
    
    //MARK: - Action button pressed function (depending on the type of the QR Code scanned)
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        qrResultType.actionToType(qrcode: qrCode!, vc:self)
        
    }
    
    //MARK: - Search the QR code scan result in Google
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
            qrResultType.searchOnGoogle(result: qrCode!.result)
    }
    
    
    //MARK: - Share button pressed function
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        let text = qrCode!.result
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - Actions to perform depending on the Contacts permission status
    
    func authorizedPermission () -> Void{
        if let data = qrCode?.result.data(using: .utf8) {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    let cancelButton = UIBarButtonItem.init(title: "Dismiss", style: .plain, target: self, action: nil)
    cancelButton.actionClosure = {
        self.dismiss(animated: true)
    }
    self.navigationItem.leftBarButtonItem = cancelButton
}

    
}
