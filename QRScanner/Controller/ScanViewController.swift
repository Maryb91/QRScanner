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
    let cp = CheckCameraPermission()
    
    //MARK: - OBOutlets
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    //MARK: - viewDidLoad Method
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openSettingsButton.isHidden = true
        checkPermission()
    }
    
    //MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        Permission.camera.request {
            self.userDefaults.set(Permission.camera.status.description, forKey: userDefaultsKeys.permissionStatusKey)
            if(self.cp.getPermissionStatus() == permissionStatusDesc.authorized){
                self.cp.displayScanVC(tabVC: self.tabBarController!)
                self.tabBarController?.selectedIndex = 0
            }
            else {
                self.arrowImage.isHidden = true
                self.qrCodeImage.isHidden = true
                self.tapLabel.text = "Please allow the Camera permission in order to start scanning QR codes"
                self.openSettingsButton.isHidden = false
            }
        }
    }
    
    
    // Open the app's settings
    @IBAction func openSettingsPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    func checkPermission()
    {
        if cp.getPermissionStatus()==permissionStatusDesc.denied{
           showNewScreen()
        }
    }
    
    
    func showNewScreen() {
        self.arrowImage.isHidden = true
        self.qrCodeImage.isHidden = true
        self.tapLabel.text = "Please allow the Camera permission in order to start scanning QR codes"
        self.openSettingsButton.isHidden = false
    }
    
    
}
