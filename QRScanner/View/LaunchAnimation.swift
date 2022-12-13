//
//  animations.swift
//  QRScanner
//
//  Created by Mariam B on 5/8/2022.
//

import Foundation
import UIKit



    //MARK: - Line animation in Launch Screen

class LaunchAnimation
{
    
    //MARK: - HoverLine method
    
    func hoverLine () -> CABasicAnimation
    {
        let hover = CABasicAnimation(keyPath: "position")
        hover.isAdditive = true
        hover.fromValue = NSValue(cgPoint: CGPoint.init(x: 0, y: 0))
        hover.toValue = NSValue(cgPoint: CGPoint(x: 0, y: 85))
        hover.autoreverses = true
        hover.duration = 0.5
        hover.repeatCount = 1
        return hover
    }
    
    //MARK: - Logo animation
    
    func animateLogo(lineLogoLaunch: UIImageView, logoLaunchImage: UIImageView,appName: UILabel, vc: LaunchViewController, loadFunction: @escaping (LaunchViewController) -> Void)
    {
        lineLogoLaunch.isHidden = true
        appName.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8)
        {
            lineLogoLaunch.isHidden = false
            appName.isHidden = false
            appName.animate(newText: "QR Code Scanner")
            lineLogoLaunch.layer.add(self.hoverLine(), forKey: "")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2)
            {
                loadFunction(vc)
            }
        }
    }
}

//MARK: - Label animation

extension UILabel {
    /**
    * @desc anime text like if someone write it
    * @param {String} text,
    * @param {TimeInterval} characterDelay,
    */
    func animate(newText: String, interval: TimeInterval = 0.07, lineSpacing: CGFloat = 1.2, letterSpacing: CGFloat = 1.1) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .center
        var pause: TimeInterval = 0
        self.text = ""
        var charIndex = 0.0
        for letter in newText {
            Timer.scheduledTimer(withTimeInterval: interval * charIndex + pause, repeats: false) { (_) in
                self.text?.append(letter)
                let attributedString = NSMutableAttributedString(string: self.text ?? "")
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length - 1))
                self.attributedText = attributedString
            }
            charIndex += 1
            if(letter == "," || letter == ".") {
                pause += 0.5
            }
        }    }
}
