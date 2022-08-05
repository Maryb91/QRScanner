//
//  LaunchViewController.swift
//  QRScanner
//
//  Created by Mariam B on 4/8/2022.
//

import UIKit

class LaunchViewController: UIViewController {

    //MARK: -Outlets
    
    @IBOutlet weak var lineLogoLaunch: UIImageView!
    @IBOutlet weak var logoLaunchImage: UIImageView!
    
    //MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineLogoLaunch.isHidden = true
        self.logoLaunchImage.rotate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.lineLogoLaunch.isHidden = false
            self.lineLogoLaunch.layer.add(hoverLine(), forKey: "myHoverAnimation")//call any function
         }
    }
}


//MARK: - Rotation animation for the logo image at Launch

extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = 2
        self.layer.add(rotation, forKey: "rotationAnimation")
}
}

//MARK: - Line animation in Launch Screen

func hoverLine () -> CABasicAnimation
{
    let hover = CABasicAnimation(keyPath: "position")
    hover.isAdditive = true
    hover.fromValue = NSValue(cgPoint: CGPoint.init(x: 0, y: 15))
    hover.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 110.5))
    hover.autoreverses = true
    hover.duration = 2
    hover.repeatCount = Float.infinity
    return hover
}
