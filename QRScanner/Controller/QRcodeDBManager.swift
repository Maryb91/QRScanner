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
    
    func saveQRCode(result: String, date: String, type: String) -> Void{
        var qrcode = QRCode()

        do {
        try realm.write {
            qrcode.result = result
            qrcode.date = date
            qrcode.type = type
            realm.add(qrcode)
        }
        }catch {
            print("Error saving a new QR code, \(error)")
        }
    }
    
    func getQRCode() -> QRCode? {
        var qrcode = realm.objects(QRCode.self).last
        return qrcode
    }
    
}
