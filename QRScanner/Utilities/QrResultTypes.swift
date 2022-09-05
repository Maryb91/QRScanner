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
import MessageUI


class QrResultTypes {
    
    //MARK: - Check the scanned QR code type according to the Prefix
    
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
    
    //MARK: - Action button titles depending on the scanned QR code's type
    
    func actionTitle(scanResultType : String) -> String {
        if(scanResultType == qrCodeTypes.textType )
        {
            return "Copy"
        }
        else if (scanResultType == qrCodeTypes.contactType)
        {
            return "Show contact details"
        }
        else if (scanResultType == qrCodeTypes.emailType)
        {
            return "Open email details"
        }
        return ""
    }
    
    //MARK: - Actions to perform in the ActionButton depending on the scanned QR code's type
    
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
        else if (qrcode.type == qrCodeTypes.emailType)
        {
            openEmailDetails(vc: vc, result: qrcode.result)
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
    //MARK: - Open email app according to the scanned QR code
    
    func openEmailDetails(vc: DetailsViewController, result: String) {
        let emailComponents = splitEmail(str: result)
        let recipientEmail = emailComponents["email"]
        let subject = emailComponents["subject"]
        let body = emailComponents["body"]
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = vc
            if let recipientEmail = emailComponents["email"]{
                mail.setToRecipients([recipientEmail])
            }
            if let subject = emailComponents["subject"]{
                mail.setSubject(subject)
            }
            if let body = emailComponents["body"]{
                mail.setMessageBody(body, isHTML: false)
            }
            vc.present(mail, animated: true, completion: nil)
            
            // Show third party email composer if default Mail app is not present
        }
        else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body, vc:vc) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    
    //MARK: - Function to create the email URL depending on the email app
    
    func createEmailUrl(to: String?, subject: String?, body: String?, vc: DetailsViewController) -> URL? {
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subject)&body=\(body)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subject)&body=\(body)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subject)&body=\(body)")
        let  sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subject)&body=\(body)")
        let  defaultUrl = URL(string: "mailto:\(to)?subject=\(subject)&body=\(body)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        else {
            let alert = UIAlertController(title: "No email app detected", message: "We could not detect any email app in your phone, please install one", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
        }
        return defaultUrl
    }
    
    
    //MARK: - Function to split the Scanned QR code to get the email, subject and body
    
    func splitEmail(str: String) -> [String:String]{
        var body = ""
        var subject = ""
        var email = ""
        let split1 = str.split(separator: ":")
        let split2 = split1[1].split(separator: "?")
        email = String(split2[0])
        let split3 = split2[1].split(separator: "&")
        let part1 = split3[0]
        let part2 = split3[1]
        let result1 = part1.split(separator: "=")
        let result2 = part2.split(separator: "=")
        if(result1[0]=="body")
        {
            body = String(result1[1])
        }
        if (result1[0]=="subject")
        {
            subject = String(result1[1])
        }
        if (result2[0]=="body")
        {
            body = String(result2[1])
        }
        if (result2[0]=="subject")
        {
            subject = String(result2[1])
        }
        let emailComponents =   ["email": email,
                                 "subject": subject,
                                 "body": body]
        return emailComponents
    }
    
    
}

