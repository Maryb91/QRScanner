//
//  DetailsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 23/8/2022.
//

import UIKit
import RealmSwift
import AVFoundation

class DetailsViewController: UIViewController {
    
    //MARK: - Variables
    
    var qrCode = QRCode()
    var qrCodeDBManager = QRCodeDBManager()
    var session = AVCaptureSession()
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var resultTextView: UITextView!
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showScannedQRCode()
    }
    
    //MARK: - Getting the scanned QR code and displaying its details
    
    func showScannedQRCode() {
        qrCode = qrCodeDBManager.getQRCode()!
        typeLabel.text = qrCode.type
        dateLabel.text = qrCode.date
        resultTextView.text = qrCode.result
    }
    
    //MARK: - Action button pressed function (depending on the type of the QR Code scanned)
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
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
    
    
    //MARK: - Actions to perform when the DetailsVC is dismissed
    
    override func viewDidDisappear(_ animated: Bool)
    {
        session.startRunning()
    }
    
}
