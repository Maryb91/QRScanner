//
//  Constants.swift
//  QRScanner
//
//  Created by Mariam B on 12/8/2022.
//

import Foundation

//MARK: - Defining the userDefaults keys

struct userDefaultsKeys {
    static let permissionStatusKey = "permissionStatus"
}

//MARK: - Storyboard IDs

struct storyBoardIds {
    static let storyBoardName = "Main"
    static let scanVCId = "scanScreen"
    static let cameraVCId = "cameraScreen"
    static let mainTabID = "mainTabID"
}

//MARK: - Scan BarItem properties

struct scanBarItem {
    static let title = "Scan"
    static let imageName = "qrcode"
}

//MARK: - Permission status descriptions

struct permissionStatusDesc {
    static let authorized = "authorized"
    static let denied = "denied"
    static let notDetermined = "not determined"
}

//MARK: - Segues identifiers

struct SegueIDs {
    static let openCamera = "openCamera"
}
