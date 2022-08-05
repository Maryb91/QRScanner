//
//  LaunchViewController.swift
//  QRScanner
//
//  Created by Mariam B on 4/8/2022.
//

import UIKit

class LaunchViewController: UIViewController {
    
    //MARK: - Variables
    var animate = animateLine()

    
    //MARK: -Outlets
            
    @IBOutlet weak var logoLaunchImage: UIImageView!
    @IBOutlet weak var lineLogoLaunch: UIImageView!
    
    
    //MARK: - View Controller
    override func viewDidLoad() {
        super.viewDidLoad()
        lineLogoLaunch.isHidden = true
        self.logoLaunchImage.rotate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                self.lineLogoLaunch.isHidden = false
                self.lineLogoLaunch.layer.add(self.animate.hoverLine(), forKey: "myHoverAnimation")//call any function
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.9) {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "scanID") as! UITabBarController
                self.present(nextViewController, animated: true, completion: nil)
            }
        }
      
    }
}



