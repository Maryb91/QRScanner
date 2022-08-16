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
    let cp = CameraPermissionChecker()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    //MARK: - viewDidLoad Method
   
    override func viewDidLoad() {
        super.viewDidLoad()
        openSettingsButton.isHidden = true
//        cp.checkCameraPermissionStatus(tabBarController: nil , VC1:nil , VC2:nil ,loadFunction: showNewScreen)
    }
    
    //MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        Permission.camera.request {
            self.userDefaults.set(Permission.camera.status.description, forKey: UserDefaultsKeys.permissionStatusKey)
//            cp.checkCameraPermissionStatus(tabBarController: self.tabBarController!, VC1: nil, VC2: nil)
//            if(self.cp.getPermissionStatus() == PermissionStatusDesc.authorized){
//                self.cp.displayScanVC(tabVC: self.tabBarController!)
//                self.tabBarController?.selectedIndex = 0
//            }
//            else {
//                self.showNewScreen()
//            }
//        }
    }
    
    //MARK: - Open settings to set the Camera Permission

    @IBAction func openSettingsPressed(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    //MARK: -  Display a new screen if the Camera Permission status is Denied
    
    func showNewScreen() {
        self.arrowImage.isHidden = true
        self.qrCodeImage.isHidden = true
        self.tapLabel.text = "Please allow the Camera permission in order to start scanning QR codes"
        self.openSettingsButton.isHidden = false
    }
    
    
    
    
//    func checkPermission()
//    {
//        if cp.getPermissionStatus()==PermissionStatusDesc.denied{
//           showNewScreen()
//        }
//    }
}
}
