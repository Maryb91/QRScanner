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
        self.layer.add(rotation, forKey: "")
    }
}

    //MARK: - Line animation in Launch Screen

class LaunchAnimation
{
    
    //MARK: - HoverLine method
    
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
    
    //MARK: - Logo animation
    
    func animateLogo(lineLogoLaunch: UIImageView, logoLaunchImage: UIImageView, vc: UIViewController)
    {
        lineLogoLaunch.isHidden = true
        logoLaunchImage.rotate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2)
        {
            lineLogoLaunch.isHidden = false
            lineLogoLaunch.layer.add(self.hoverLine(), forKey: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9)
            {
                self.loadTabBarController(vc: vc)
            }
        }
    }
    
    //MARK: - Load tabBarController
    
    func loadTabBarController(vc: UIViewController)
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: storyBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: storyBoardIds.mainTabID) as! mainTabBarController
        vc.present(newViewController, animated: true, completion: nil)
    }
}
