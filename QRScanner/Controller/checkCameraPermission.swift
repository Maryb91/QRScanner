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
    var permissionStatus = Permission.camera.status.description
    
    
    //MARK: - A method to choose which ViewController to display in the Scan tabBarItem
    
    func displayScanVC (tabVC: UITabBarController) {
        let storyboard = UIStoryboard(name: storyBoardIds.storyBoardName, bundle: nil)
        let scanVC = storyboard.instantiateViewController(withIdentifier: storyBoardIds.scanVCId)
        let cameraVC = storyboard.instantiateViewController(withIdentifier: storyBoardIds.cameraVCId)
        let scanBaritem = UITabBarItem(title: scanBarItem.title, image: UIImage(systemName: scanBarItem.imageName) , tag: 0)
        scanVC.tabBarItem = scanBaritem
        cameraVC.tabBarItem = scanBaritem
        if(permissionStatus == permissionStatusDesc.authorized){
            tabVC.viewControllers![0] = cameraVC
        }
        else if (permissionStatus == permissionStatusDesc.denied || permissionStatus == permissionStatusDesc.notDetermined){
            tabVC.viewControllers![0] = scanVC
        }
    }
    
}
