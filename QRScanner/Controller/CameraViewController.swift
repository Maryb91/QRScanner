//
//  CameraViewController.swift
//  QRScanner
//
//  Created by Mariam B on 9/8/2022.
//
import UIKit
import AVFoundation
import PermissionsKit
import PhotoLibraryPermission
import PhotosUI

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate{
    
   
    //MARK: - IBoutlets
    
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var scanImageView: UIImageView!
    
    //MARK: - Variables
    
    let session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var cornerView : Corners?
    var pc = PermissionChecker()
    var qrCodeResult = QrCodeResult()
    let userDefaults = UserDefaults.standard

    //MARK: - viewDidLoad Method
    
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
    
        menuView.layer.cornerRadius = 30
        view.bringSubviewToFront(menuView)
        view.bringSubviewToFront(cornerView!)
        view.bringSubviewToFront(cameraLabel)
        view.bringSubviewToFront(galleryButton)
        view.bringSubviewToFront(flashButton)
    }
    
    //MARK: - MetaDataOutput - Delegate method
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metaDataObject = metadataObjects.first {
            guard let readableObject = metaDataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            if (userDefaults.bool(forKey: "vibrate"))
            {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            if let result = readableObject.stringValue{
            qrCodeResult.getQrCodeResult(qrCodeString: result,picker: nil,vc: self, qrCodeScanSource: "Camera")
            session.stopRunning()
            }
        }
    }
    
    //MARK: - Change flash state ON or OFF
    
    @IBAction func flashState(_ sender: UIButton) {
        flashButton.setImage(UIImage(systemName: "flashlight.off.fill"), for: .normal)
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            return
        }
        do {
            try device.lockForConfiguration()
            let torchOn = !device.isTorchActive
            try device.setTorchModeOn(level: 1.0)
            device.torchMode = torchOn ? .on : .off
            if (torchOn){
                flashButton.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
            }
            device.unlockForConfiguration()
        } catch {
            print("err")
        }
    }
    
    
    //MARK: - Open Photo Library button actions
    
    @IBAction func openGalleryButtonPressed(_ sender: UIButton) {
        Permission.photoLibrary.request {
            self.pc.checkPhotoLibraryPermissionStatus(authorizedFunc: self.authorizedPermission, deniedFunc: self.deniedPermission, limitedFunc: self.limitedPermission, vc: self)
        }
    }
    
    
    //MARK: - Reading QR Codes from images in the Photo Library function (all photos)
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                if let qrcodeImg = object as? UIImage {
                    DispatchQueue.main.async {
                        let detector:CIDetector=CIDetector.init(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
                        let ciImage:CIImage=CIImage(image:qrcodeImg)!
                        var qrCodeString=""
                        let features=detector.features(in: ciImage) as? [CIQRCodeFeature]
                        for feature in features! {
                            qrCodeString += feature.messageString!
                        }
                        self.qrCodeResult.getQrCodeResult(qrCodeString: qrCodeString,picker: picker,vc: self, qrCodeScanSource: "PhotoLibrary")
                    }
                }
                else {
                    picker.dismiss(animated: true, completion: nil)
                }
            })
        }
    }

    
    
    //MARK: - Actions to perform depending on the Photo Library permission status
    
    func authorizedPermission () -> Void{
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        let pickerViewController = PHPickerViewController(configuration: config)
        pickerViewController.delegate = self
        self.present(pickerViewController, animated: true, completion: nil)
    }
    
    
    func deniedPermission() -> Void{
        let settingsAlert = UIAlertController(title: "Allow permission", message: "Please allow the photo library permission from the app settings to scan QR code images", preferredStyle: UIAlertController.Style.alert)
        settingsAlert.addAction(UIAlertAction(title: "Go to settings", style: .default, handler: { (action: UIAlertAction!) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }))
        settingsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            settingsAlert.dismiss(animated: true, completion: nil)
        }))
        self.present(settingsAlert, animated: true, completion: nil)
    }
    
    
    func limitedPermission(vc: CameraViewController) -> Void {
        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
    }
    
    //MARK: - Passing the parameteres to DetailsViewController
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          let detailsVC = segue.destination as! DetailsViewController
          detailsVC.session = session
      }
}

