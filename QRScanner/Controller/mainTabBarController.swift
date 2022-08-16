//
//  mainTabBarController.swift
//  QRScanner
//
//  Created by Mariam B on 11/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission


class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Variables
    
    var cp = CameraPermissionChecker()
    var storyBoard = UIStoryboard()
    var scanVC = UIViewController()
    var cameraVC = UIViewController()
    
    //MARK: - viewDidLoad method

    override func viewDidLoad() {
        super.viewDidLoad()
        storyBoard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        scanVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.scanVCId)
        cameraVC = storyboard!.instantiateViewController(withIdentifier: StoryBoardIds.cameraVCId)
        self.displayScanVC(tabVC: self)
    }
    
    //MARK: - viewWillAppear method
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
    }
    
    //MARK: - Display ViewControllers according to the camera permission status in the first tab
    
    func displayScanVC (tabVC: UITabBarController) {
        let ScanBarItem = UITabBarItem(title: ScanBarItem.title, image: UIImage(systemName: ScanBarItem.imageName) , tag: 0)
        scanVC.tabBarItem = ScanBarItem
        cameraVC.tabBarItem = ScanBarItem
        cp.checkCameraPermissionStatus(authorizedFunc: authorizedPermission, deniedFunc: deniedPermission)
    }
    
    
    //MARK: - Actions to perform depending on the Camera permission status
    
    func authorizedPermission () -> Void{
        self.viewControllers![0] = cameraVC
    }
    
    func deniedPermission() -> Void{
        self.viewControllers![0] = scanVC

    }
}
