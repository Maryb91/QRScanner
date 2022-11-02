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

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lineLogoLaunch: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var logoLaunchImage: UIImageView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        animate.animateLogo(lineLogoLaunch: lineLogoLaunch,logoLaunchImage: logoLaunchImage, appName:self.appName ,vc: self,loadFunction: self.loadTabBarController)
        loadTabBarController(vc: self)
    }
    
    
    //MARK: - Load the first screen after launching animation finishes
    
    func loadTabBarController(vc: LaunchViewController) -> Void
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: StoryBoardIds.storyBoardName, bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: StoryBoardIds.mainTabID) as! MainTabBarViewController
        vc.present(newViewController, animated: true, completion: nil)
    }
}



