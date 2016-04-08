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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

