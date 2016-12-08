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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        let vm :HomeViewModel = HomeViewModel.init()
        
        let home = HomePageViewController.init(WithViewModel: vm)
        let left = LeftMenuViewController.init(nibName: "LeftMenuViewController", bundle: Bundle.main)
        
        mainVC = MainViewController.init(withHomePage:home ,andWithLeft: left)
        let navigationController = UINavigationController.init(rootViewController: mainVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        self.setLauchView()
        
        return true
    }

    func setLauchView() {
        launchImaViewT = UIImageView.init(frame: UIScreen.main.bounds)
        launchImaViewT.contentMode = UIViewContentMode.scaleAspectFill
        self.window?.addSubview(launchImaViewT!)
        
        launchImaViewO = UIImageView.init(frame: UIScreen.main.bounds)
        launchImaViewO.image = UIImage.init(contentsOfFile: Bundle.main.path(forResource: "Default@2x", ofType: "png")!)
        self.window?.addSubview(launchImaViewO)
        
        Alamofire.request("http://news-at.zhihu.com/api/4/start-image/1080*1776", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                print("JSON: \(JSON)")
                let imageUrl = JSON["img"] as! String
                self.launchImaViewT.af_setImage(withURL: URL.init(string: imageUrl)!)
                UIView.animate(withDuration: 2.0, animations: {
                    self.launchImaViewO.alpha = 0
                    self.launchImaViewT.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }, completion: { (finished) in
                    self.launchImaViewO.removeFromSuperview()
                    self.launchImaViewT.removeFromSuperview()
                } )
                
            }
        }
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CarouseViewTimerPause"), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "CarouseViewTimerRestore"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

