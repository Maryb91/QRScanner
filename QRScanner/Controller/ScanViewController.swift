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
    
    @IBOutlet weak var tapLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var openSettingsButton: UIButton!
    
    //MARK: - viewDidLoad Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openSettingsButton.isHidden = true
        storyBoard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        scanVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.scanVCId)
        cameraVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.cameraVCId)
    }
    
    //MARK: - iBAction cameraButtonPressed
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        Permission.camera.request {
               self.pc.checkCameraPermissionStatus(authorizedFunc: self.authorizedPermission, deniedFunc: self.deniedPermission)
        }
    }
    
    //MARK: - Open settings to set the Camera Permission
    
    @IBAction func openSettingsPressed(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    //MARK: -  Display a new screen if the Camera Permission status is Denied
    
    func showNewScreen() {
        self.arrowImage.isHidden = true
        self.qrCodeImage.isHidden = true
        self.tapLabel.text = "Please allow the Camera permission in order to start scanning QR codes"
        self.openSettingsButton.isHidden = false
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
