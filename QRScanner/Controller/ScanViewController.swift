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
    
    var pc = PermissionChecker()
    var storyBoard = UIStoryboard()
    var scanVC = UIViewController()
    var cameraVC = UIViewController()
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var cameraDeniedLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var cemraPermissionLabel: UILabel!
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBoard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        scanVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.scanVCId)
        cameraVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.cameraVCId)
        actionButtonLayout()
        showScreen()
      
    }
  
    //MARK: - Button's Action depending on the Camera Permission
    
    @IBAction func actionButtonPressed(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)

    }
    
    
    //MARK: -  Display a new screen if the Camera Permission status is Denied
    
    func showScreen() {
            actionButton.setTitle("Open Settings", for: .normal)
            imageIcon.image = UIImage(named: "cameraIcon.png")
            cemraPermissionLabel.text = "Please allow the Camera access from the Settings, otherwise the app won't be able to scan QR codes."
            cameraDeniedLabel.isHidden = false
          NSLayoutConstraint(item: cemraPermissionLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cameraDeniedLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8).isActive = true
        }
    
    //MARK: - Action Button Layout
    
    func actionButtonLayout() {
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.systemIndigo.cgColor
        actionButton.layer.cornerRadius = 8
    }

    


}
