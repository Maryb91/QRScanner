//
//  CameraViewController.swift
//  QRScanner
//
//  Created by Mariam B on 9/8/2022.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    //MARK: - IBoutlets
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var scanImageView: UIImageView!
    
    //MARK: - Variables
    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var cornerView : Corners?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayScanner()
    }
    

    //MARK: - Display Scanner Method
    
    func displayScanner () {
        session.startRunning()
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
         do {
              let input = try AVCaptureDeviceInput(device: captureDevice!)
              session.addInput(input)
          } catch {
              print("Error capturing QRCode")
          }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        self.cornerView = Corners(frame: scanImageView.frame)
        view.addSubview(self.cornerView!)
        self.cornerView!.layoutCorners(view: self.view, imageView: scanImageView)
        view.bringSubviewToFront(cornerView!)
        view.bringSubviewToFront(cameraLabel)

    }
    
    //MARK: - MetaDataOutput - Delegate method
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           if let metaDataObject = metadataObjects.first {
               guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else {
                   return
               }
               AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
               let alert = UIAlertController(title: "QRCode", message: readableObject.stringValue, preferredStyle: .actionSheet)

               alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { action in
                   self.session.startRunning()
               }))
               present(alert, animated: true, completion: nil)
           }
       }
}



