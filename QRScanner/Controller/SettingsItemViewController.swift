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
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    //MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = labelTitle
        iconImage
            .layer.cornerRadius = 15

        
    }
    

}
