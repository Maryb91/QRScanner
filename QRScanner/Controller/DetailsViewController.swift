//
//  DetailsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 23/8/2022.
//

import UIKit

class DetailsViewController: UIViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var resultTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    //MARK: - Action button pressed function (depending on the type of the QR Code scanned)
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
    }
    
    
    //MARK: - Share button pressed function
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
    }
    
}
