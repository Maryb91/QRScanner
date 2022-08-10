//
//  ScanViewController.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission

class ScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
       //let permissionStatus = Permission.camera.status
    }

   
//MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "openCamera", sender: self)
        
//        Permission.camera.request {
//
//        }
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//                   let imagePickerController = UIImagePickerController()
//                   imagePickerController.delegate = self;
//                   imagePickerController.sourceType = .camera
//                   self.present(imagePickerController, animated: true, completion: nil)
//               }
       
    }
}
