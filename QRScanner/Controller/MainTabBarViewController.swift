//
//  mainTabBarController.swift
//  QRScanner
//
//  Created by Mariam B on 11/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission


class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Variables
    
    var cp = PermissionChecker()
    var storyBoard = UIStoryboard()
    var scanVC = ScanViewController()
    var cameraVC = UIViewController()
    
    //MARK: - viewDidLoad method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storyBoard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        scanVC =  storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.scanVCId) as! ScanViewController
        cameraVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.cameraVCId) as! CameraViewController
        
    }
    
    //MARK: - viewWillAppear method
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        self.displayScanVC(tabVC: self)
    }
    
    //MARK: - Display ViewControllers according to the camera permission status in the first tab
    
    func displayScanVC (tabVC: UITabBarController) {
        let ScanBarItem = UITabBarItem(title: ScanBarItem.title, image: UIImage(systemName: ScanBarItem.imageName) , tag: 0)
        scanVC.tabBarItem = ScanBarItem
        cameraVC.tabBarItem = ScanBarItem
        cp.checkCameraPermissionStatus(authorizedFunc: authorizedPermission, deniedFunc: deniedPermission, notDetermined: notDeterminedPermission)
    }
    
    
    //MARK: - Actions to perform depending on the Camera permission status
    
    func authorizedPermission () -> Void{
        self.viewControllers![0] = cameraVC
    }
    
    func deniedPermission() -> Void{
        self.viewControllers![0] = scanVC
    }
    
    func notDeterminedPermission ()-> Void{
        self.viewControllers![0] = cameraVC
    }
}
