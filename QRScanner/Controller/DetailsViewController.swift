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
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    
    //MARK: - Actions to perform when the DetailsVC is dismissed
    
    override func viewDidDisappear(_ animated: Bool) {
        session.startRunning()
    }
    
}
