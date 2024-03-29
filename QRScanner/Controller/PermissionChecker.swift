//
//  PermissionChecker.swift
//  SharpQRScanner
//
//

import Foundation
import UIKit
import PermissionsKit
import PhotosUI

class PermissionChecker {
    
    
    //MARK: - Get Camera permission status
    
    func getCameraPermissionStatus() -> String
    {
        return Permission.camera.status.description
    }
    
    //MARK: - Checking the Camera Permission Status
    
    func checkCameraPermissionStatus (authorizedFunc: () -> Void, deniedFunc: ()-> Void , notDetermined: () -> Void = {})
    {
        if(getCameraPermissionStatus() == PermissionStatusDesc.authorized)
        {
            authorizedFunc()
        }
        else if (getCameraPermissionStatus() == PermissionStatusDesc.denied)
        {
            deniedFunc()
        }
        else
        {
            notDetermined ()
        }
    }
    
    //MARK: -  Get Photo Library permission status
    
    func getPhotoLibraryPermissionStatus() -> PHAuthorizationStatus
    {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    //MARK: - Checking the Photo Library Permission Status
    
    func checkPhotoLibraryPermissionStatus (authorizedFunc: () -> Void, deniedFunc: ()-> Void , limitedFunc: (CameraViewController) -> Void, vc: CameraViewController)
    {
        let status = getPhotoLibraryPermissionStatus()
        switch status
        {
        case .notDetermined:
            print("not determined")
        case .authorized:
            authorizedFunc()
        case .restricted, .denied:
            deniedFunc()
        case .limited:
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: vc)
        }
    }
    
    //MARK: -  Get Contacts permission status
    
    func getContactsPermissionStatus() -> String
    {
        return Permission.contacts.status.description
    }
    
    
    //MARK: - Checking the Contacts Permission Status
    
    func checkContactPermissionStatus (authorizedFunc: () -> Void, deniedFunc: ()-> Void)
    {
        if(getContactsPermissionStatus() == PermissionStatusDesc.authorized)
        {
            authorizedFunc()
        }
        else if (getContactsPermissionStatus() == PermissionStatusDesc.denied)
        {
            deniedFunc()
        }
    }
}

