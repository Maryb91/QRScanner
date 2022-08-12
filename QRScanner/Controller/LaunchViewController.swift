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
        print("Permission status is", userDefaults.string(forKey: userDefaultsKeys.permissionStatusKey))
        //animate.animateLogo(lineLogoLaunch: lineLogoLaunch,logoLaunchImage: logoLaunchImage,vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate.loadTabBarController(vc: self)
    }
    

}



