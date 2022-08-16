//
//  CameraPermissionChecker.swift
//  QRScanner
//
//  Created by Mariam B on 11/8/2022.
//

import Foundation
import UIKit
import PermissionsKit
import CameraPermission

class CameraPermissionChecker {
    
    //MARK: - Class properties
    
    
    
    //MARK: - Get Camera permission status from UserDefaults
    
    func getPermissionStatus() -> String {
        return Permission.camera.status.description
    }
    
    //MARK: - Checking the Camera Permission Status
    
    func checkCameraPermissionStatus (authorizedFunc: () -> Void, deniedFunc: ()-> Void , notDetermined: () -> Void = {})
    {
        if(getPermissionStatus() == PermissionStatusDesc.authorized)
        {
            authorizedFunc()
        }
        else if (getPermissionStatus() == PermissionStatusDesc.denied)
        {
            deniedFunc()
        }
        else {
            notDetermined ()
        }
    }
}
