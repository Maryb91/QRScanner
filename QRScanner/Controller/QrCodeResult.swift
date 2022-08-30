//
//  qrCodeResult.swift
//  QRScanner
//
//  Created by Mariam B on 25/8/2022.
//

import Foundation
import PhotosUI


// A class that manages the result of the QR code scanned
class QrCodeResult {
    
    //MARK: - Variables
    
    var typeChecker  = QrResultTypes()
    var qrCodeDBManager = QRCodeDBManager()
    var qrCode = QRCode()
    
    //MARK: - When the QR code is scanned from the Photo Library
    
    func getQrCodeResult(qrCodeString: String, picker: PHPickerViewController?, vc: CameraViewController, qrCodeScanSource : String) -> QRCode {
        
        if qrCodeString.isEmpty {
            let alert = UIAlertController(title: "Invalid QRCode", message: "The QR code is invalid, please provide a clear image", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            if(qrCodeScanSource==permissionSource.photoLibrarySource)
            {
                picker!.dismiss(animated: true, completion: nil)
            }
        } else {
             qrCodeDBManager.saveQRCode(result: qrCodeString, date: vc.getDate(), type: typeChecker.checkType(result: qrCodeString))
            vc.performSegue(withIdentifier: "showDetails", sender: vc)
            if(qrCodeScanSource==permissionSource.photoLibrarySource)
            {
                picker!.dismiss(animated: true, completion: nil)
            }
        }
        return qrCode
    }
}
