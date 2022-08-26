//
//  qrTypes.swift
//  QRScanner
//
//  Created by Mariam B on 25/8/2022.
//

import Foundation


class QrResultTypes {
    
    func checkType(result: String) -> String{
        if result.hasPrefix("mailto:")
        {
            return "Email"
        }
        else if result.hasPrefix("tel:"){
            return "Phone"
        }
        else if result.hasPrefix("BEGIN:VCARD")
        {
            return "Contact"
        }
        else if result.lowercased().hasPrefix("http://") || result.lowercased().hasPrefix("https://") || result.lowercased().hasPrefix("www.")
        {
            return "Website"
        }
        else
        {
            return "Text"
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

