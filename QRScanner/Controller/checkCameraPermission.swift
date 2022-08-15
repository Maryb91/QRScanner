//
//  checkCameraPermission.swift
//  QRScanner
//
//  Created by Mariam B on 11/8/2022.
//

import Foundation
import UIKit
import PermissionsKit
import CameraPermission

class checkCameraPermission {
    
    //MARK: - Class properties
   // var permissionStatus = Permission.camera.status.description
    let userDefaults = UserDefaults.standard

    //MARK: - A method to choose which ViewController to display in the Scan tabBarItem
    
    func displayScanVC (tabVC: UITabBarController) {
        let storyboard = UIStoryboard(name: storyBoardIds.storyBoardName, bundle: nil)
        let scanVC = storyboard.instantiateViewController(withIdentifier: storyBoardIds.scanVCId)
        let cameraVC = storyboard.instantiateViewController(withIdentifier: storyBoardIds.cameraVCId)
        let scanBaritem = UITabBarItem(title: scanBarItem.title, image: UIImage(systemName: scanBarItem.imageName) , tag: 0)
        scanVC.tabBarItem = scanBaritem
        cameraVC.tabBarItem = scanBaritem
        if(getPermissionStatus() == permissionStatusDesc.authorized){
            tabVC.viewControllers![0] = cameraVC
        }
        else if (getPermissionStatus() == permissionStatusDesc.denied || getPermissionStatus() == permissionStatusDesc.notDetermined){
            tabVC.viewControllers![0] = scanVC
        }
    }
    
    //MARK: - Get Camera permission status from UserDefaults
    
    func getPermissionStatus() -> String {
        if let status = userDefaults.string(forKey: userDefaultsKeys.permissionStatusKey)
        {
            return status
        }
        else {
            return permissionStatusDesc.notDetermined
        }
    }
}
