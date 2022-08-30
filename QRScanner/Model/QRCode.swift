//
//  QRCode.swift
//  QRScanner
//
//  Created by Mariam B on 24/8/2022.
//

import Foundation
import RealmSwift

class QRCode: Object
{
    @Persisted(primaryKey: true) var uuid = UUID().uuidString
    @Persisted var result: String = ""
    @Persisted var type: String = ""
    @Persisted var date : String = ""
}
