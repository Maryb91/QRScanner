//
//  QRCode.swift
//  QRScanner
//
//  Created by Mariam B on 24/8/2022.
//

import Foundation
import RealmSwift

class QRCode: Object {
    @objc dynamic var result: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var date = Date()
}
