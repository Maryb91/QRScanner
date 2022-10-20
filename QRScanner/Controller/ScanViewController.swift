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
        if(pc.getCameraPermissionStatus() == PermissionStatusDesc.notDetermined)
        {
            showFirstScreen()
        }
    }
  
    //MARK: - Button's Action depending on the Camera Permission
    
    @IBAction func actionButtonPressed(_ sender: UIButton)
    {
        if (pc.getCameraPermissionStatus() == PermissionStatusDesc.notDetermined)
        {
            Permission.camera.request {
                   self.pc.checkCameraPermissionStatus(authorizedFunc: self.authorizedPermission, deniedFunc: self.deniedPermission)
            }
        }
        else if (pc.getCameraPermissionStatus() == PermissionStatusDesc.denied){
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
    
//MARK: - First screen Layout when the Camera Permission is not Determined
    
    func showFirstScreen() {
        actionButton.setTitle("Start scanning", for: .normal)
                NSLayoutConstraint(item: cemraPermissionLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageIcon, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 20).isActive = true
        imageIcon.tintColor = .systemIndigo
        imageIcon.image = UIImage(systemName: "qrcode")
        cameraDeniedLabel.isHidden = true
        cemraPermissionLabel.text = "Please allow the Camera permission in order to start scanning QR codes"
        cemraPermissionLabel.font = cemraPermissionLabel.font.withSize(20)
    }
    
    //MARK: -  Display a new screen if the Camera Permission status is Denied
    
    func showNewScreen() {
            actionButton.setTitle("Open Settings", for: .normal)
            imageIcon.image = UIImage(named: "cameraIcon.png")
            cemraPermissionLabel.text = "Please grant the Camera permission from the Settings, Otherwise the app won't be able to scan QR codes."
            cameraDeniedLabel.isHidden = false
        NSLayoutConstraint(item: cemraPermissionLabel, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: cameraDeniedLabel, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 8).isActive = true
        }
    
    //MARK: - Action Button Layout
    
    func actionButtonLayout() {
        actionButton.layer.borderWidth = 1
        actionButton.layer.borderColor = UIColor.systemIndigo.cgColor
        actionButton.layer.cornerRadius = 8
    }

    
    //MARK: - Actions to perform depending on the Camera permission status
    
    func authorizedPermission () -> Void{
        let ScanBarItem = UITabBarItem(title: ScanBarItem.title, image: UIImage(systemName: ScanBarItem.imageName) , tag: 0)
        scanVC.tabBarItem = ScanBarItem
        cameraVC.tabBarItem = ScanBarItem
        self.tabBarController?.viewControllers![0] = cameraVC
        self.tabBarController?.selectedIndex = 0
    }
    
    func deniedPermission() -> Void{
        showNewScreen()
    }
    

}
