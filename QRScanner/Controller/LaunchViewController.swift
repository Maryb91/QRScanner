//
//  LaunchViewController.swift
//  QRScanner
//
//  Created by Mariam B on 4/8/2022.
//

import UIKit
import PermissionsKit
import CameraPermission


class LaunchViewController: UIViewController {
    
    //MARK: - Variables
    var animate = LaunchAnimation()
    let userDefaults = UserDefaults.standard

    //MARK: -Outlets
    
    @IBOutlet weak var logoLaunchImage: UIImageView!
    @IBOutlet weak var lineLogoLaunch: UIImageView!
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        animate.animateLogo(lineLogoLaunch: lineLogoLaunch,logoLaunchImage: logoLaunchImage,vc: self)
        animate.loadTabBarController(vc: self)
    }
}



