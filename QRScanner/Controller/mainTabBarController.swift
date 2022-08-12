//
//  mainTabBarController.swift
//  QRScanner
//
//  Created by Mariam B on 11/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission


class mainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Variables
    
    var cp = checkCameraPermission()
   
    //MARK: - viewDidLoad method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cp.displayScanVC(tabVC: self)
    }
    
    //MARK: - viewWillAppear method
    
    override func viewWillAppear(_ animated: Bool) {
            self.tabBarController?.delegate = self
    }
}
