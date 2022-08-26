//
//  QRcodeDB.swift
//  QRScanner
//
//  Created by Mariam B on 26/8/2022.
//

import Foundation
import RealmSwift

// A class that manages the Database operations for the QR codes scanned

class QRCodeDBManager {
    
    //MARK: - Variables
    
    let realm = try! Realm()
    
//MARK: - Saving QR codes scanned in the Database
    
    func saveQRCode(qrcode : QRCode) {
        try! realm.write {
            realm.add(qrcode)
              }
    }
    
}
