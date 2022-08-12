//
//  ScanViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission

class ScanViewController: UIViewController, UIImagePickerControllerDelegate {
    
    //MARK: - Variables
    let userDefaults = UserDefaults.standard
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: SegueIDs.openCamera, sender: self)
        Permission.camera.request {
            self.userDefaults.set(Permission.camera.status.description, forKey: userDefaultsKeys.permissionStatusKey)
        }
        
        //        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        //                   let imagePickerController = UIImagePickerController()
        //                   imagePickerController.delegate = self;
        //                   imagePickerController.sourceType = .camera
        //                   self.present(imagePickerController, animated: true, completion: nil)
        //
        //
        //    }
        
    }
}
