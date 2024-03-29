//
//  qrCodeResult.swift
//  SharpQRScanner
//
//

import Foundation
import PhotosUI
import ContactsUI

// A class that manages the result of the QR code scanned
class QrCodeResult {
    
    //MARK: - Variables
    
    var typeChecker  = QrResultTypes()
    var qrCodeDBManager = QRCodeDBManager()
    
    //MARK: - Actions to perform according to the scan result (empty or returned)
    
    func getQrCodeResult(qrCodeString: String, picker: PHPickerViewController?, vc: UIViewController, qrCodeScanSource : String, session : AVCaptureSession?) -> Void {
        
        if qrCodeString.isEmpty {
            let alert = UIAlertController(title: "Invalid QRCode", message: "The QR code is invalid, please provide a clear image", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            vc.present(alert, animated: true, completion: nil)
            if(qrCodeScanSource==permissionSource.photoLibrarySource)
            {
                picker!.dismiss(animated: true, completion: nil)
            }
        } else {
            qrCodeDBManager.saveQRCode(result: qrCodeString, date:getDate(), type: typeChecker.checkType(scanResult:qrCodeString))
            session?.stopRunning()
            vc.performSegue(withIdentifier: "showDetails", sender: vc)
            if(qrCodeScanSource==permissionSource.photoLibrarySource)
            {
                picker!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    //MARK: - Get current Date function
    
    func getDate() -> String
    {
        let currentTime = Date()
        let format = DateFormatter()
        format.timeStyle = .medium
        format.dateStyle = .medium
        return format.string(from: currentTime)
    }
}

