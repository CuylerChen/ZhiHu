//
//  AppDelegate.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchImaViewO: UIImageView!
    var launchImaViewT: UIImageView!
    var mainVC: MainViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        let vm :HomeViewModel = HomeViewModel.init()
        
        let home = HomePageViewController.init(WithViewModel: vm)
        let left = LeftMenuViewController.init(nibName: "LeftMenuViewController", bundle: NSBundle.mainBundle())
        
        mainVC = MainViewController.init(withHomePage:home ,andWithLeft: left)
        let navigationController = UINavigationController.init(rootViewController: mainVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        navigationController.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        self.setLauchView()
        
        return true
    }

    func setLauchView() {
        launchImaViewT = UIImageView.init(frame: UIScreen.mainScreen().bounds)
        launchImaViewT.contentMode = UIViewContentMode.ScaleAspectFill
        self.window?.addSubview(launchImaViewT!)
        
        launchImaViewO = UIImageView.init(frame: UIScreen.mainScreen().bounds)
        launchImaViewO.image = UIImage.init(contentsOfFile: NSBundle.mainBundle().pathForResource("Default@2x", ofType: "png")!)
        self.window?.addSubview(launchImaViewO)
        
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/start-image/1080*1776")
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let imageUrl = JSON["img"] as! String
                    self.launchImaViewT.af_setImageWithURL(NSURL.init(string: imageUrl)!)
                    UIView.animateWithDuration(2.0, animations: {
                        self.launchImaViewO.alpha = 0
                        self.launchImaViewT.transform = CGAffineTransformMakeScale(1.2, 1.2)
                        }, completion: { (finished) in
                        self.launchImaViewO.removeFromSuperview()
                        self.launchImaViewT.removeFromSuperview()
                    } )
 
                }
        }
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("CarouseViewTimerPause", object: nil)
    }

    func applicationDidEnterBackground(application: UIApplication) {
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        NSNotificationCenter.defaultCenter().postNotificationName("CarouseViewTimerRestore", object: nil)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

