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
    let cp = CameraPermissionChecker()
    //MARK: -Outlets
    
    @IBOutlet weak var logoLaunchImage: UIImageView!
    @IBOutlet weak var lineLogoLaunch: UIImageView!
    
    //MARK: - View Controller
    override func viewDidLoad()
    {
        super.viewDidLoad()
        animate.animateLogo(lineLogoLaunch: lineLogoLaunch,logoLaunchImage: logoLaunchImage,vc: self,loadFunction: self.loadTabBarController)
    }
    
    func loadTabBarController(vc: LaunchViewController) -> Void
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarController
        vc.present(newViewController, animated: true, completion: nil)
    }
}



