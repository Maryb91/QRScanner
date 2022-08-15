//
//  ScanViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UITabBarControllerDelegate {
    
    //MARK: - Variables
    
    let userDefaults = UserDefaults.standard
    let cp = checkCameraPermission()
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        Permission.camera.request {
            self.userDefaults.set(Permission.camera.status.description, forKey: userDefaultsKeys.permissionStatusKey)
            if(self.cp.getPermissionStatus() == permissionStatusDesc.authorized){
                self.tabBarController?.selectedIndex = 0
            }
            else {
                print("denied")
            }
        }
    }
}
