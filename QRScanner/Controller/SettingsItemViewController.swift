//
//  AboutUsViewController.swift
//  QRScanner
//
//  Created by Mariam B on 28/9/2022.
//

import UIKit

class SettingsItemViewController: UIViewController {
    
    //MARK: - Variables
    
    var labelTitle = ""
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var textLabel: UILabel!
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = labelTitle

    }
    

}
