//
//  qrTypes.swift
//  QRScanner
//
//  Created by Mariam B on 25/8/2022.
//

import Foundation
import UIKit
import ContactsUI
import PermissionsKit
import ContactsPermission

class QrResultTypes {
    
    
    func checkType(scanResult: String) -> String{
        if scanResult.hasPrefix("mailto:")
        {
            return qrCodeTypes.emailType
        }
        else if scanResult.hasPrefix("tel:"){
            return qrCodeTypes.phoneType
        }
        else if scanResult.hasPrefix("BEGIN:VCARD")
        {
            return qrCodeTypes.contactType
        }
        else if scanResult.lowercased().hasPrefix("http://") || scanResult.lowercased().hasPrefix("https://") || scanResult.lowercased().hasPrefix("www.")
        {
            return qrCodeTypes.websiteType
        }
        else
        {
            return qrCodeTypes.textType
        }
    }
    
    //MARK: - Action button titles depending on the QR code scanned type
    
    func actionTitle(scanResultType : String) -> String {
        if(scanResultType == qrCodeTypes.textType )
        {
            return "Copy"
        }
        else if (scanResultType == qrCodeTypes.contactType)
        {
            return "Show contact details"
        }
        return ""
    }
    
    //MARK: - Actions to perform in the ActionButton depending on the QR code scanned type
    
    func actionToType(qrcode : QRCode, vc: DetailsViewController)
    {
        if(qrcode.type == qrCodeTypes.textType)
        {
            copyText(scanResult: qrcode.result)
        }
        else if (qrcode.type == qrCodeTypes.contactType)
        {
            getContactDetails(vc: vc)
        }
    }
    
    
    //MARK: - Function to copy text to the Clipboard
    
    func copyText(scanResult : String)
    {
        UIPasteboard.general.string = scanResult
    }
    
    
    //MARK: - Displaying the contact screen according to the QRcode scan result
    
    func getContactDetails(vc: DetailsViewController) {
        Permission.contacts.request{
            vc.pc.checkContactPermissionStatus(authorizedFunc: vc.authorizedPermission, deniedFunc: vc.deniedPermission)
        }
    }
    
    
    
    
    
    
    
    
}






//    //MARK: - Slice strings between two strings function
//
//        func slice(from: String, to: String) -> String {
//            return (range(of: from)?.upperBound).flatMap { substringFrom in
//                (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
//                    String(self[substringFrom..<substringTo])
//                }
//            } as! String
//        }
//
//
//}

