//
//  Constants.swift
//  QRScanner
//
//  Created by Mariam B on 12/8/2022.
//

import Foundation


//MARK: - Storyboard IDs

struct StoryBoardIds {
    static let storyBoardName = "Main"
    static let scanVCId = "scanScreen"
    static let cameraVCId = "cameraScreen"
    static let mainTabID = "mainTabID"
    static let historyVCId = "historyID"
}

//MARK: - Scan BarItem properties

struct ScanBarItem {
    static let title = "Scan"
    static let imageName = "qrcode"
}


//MARK: - History BarItem properties

struct HistoryBarItem {
    static let title = "History"
    static let imageName = "clock"
}

//MARK: - Permission status descriptions

struct PermissionStatusDesc {
    static let authorized = "authorized"
    static let denied = "denied"
    static let notDetermined = "not determined"
}

//MARK: - Segues identifiers

struct SegueIDs {
    static let openCamera = "openCamera"
}

//MARK: - Permission types

struct permissionSource {
    static let cameraSource = "Camera"
    static let photoLibrarySource = "PhotoLibrary"
}

//MARK: - QR code types

struct qrCodeTypes {
    static let textType = "Text"
    static let contactType = "Contact"
    static let emailType = "Email"
    static let phoneType = "Phone"
    static let websiteType = "Website"
}
