//
//  animations.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import Foundation
import UIKit

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

class animateLine
{
    func hoverLine () -> CABasicAnimation
{
    let hover = CABasicAnimation(keyPath: "position")
    hover.isAdditive = true
    hover.fromValue = NSValue(cgPoint: CGPoint.init(x: 0, y: 0))
    hover.toValue = NSValue(cgPoint: CGPoint(x: 0.0, y: 110.5))
    hover.autoreverses = true
    hover.duration = 0.5
    hover.repeatCount = 2
    return hover
}
}
