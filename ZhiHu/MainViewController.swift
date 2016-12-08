//
//  MainViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var homeViewController: HomePageViewController!
    var leftMenuViewController: LeftMenuViewController!
    var distance: CGFloat = 0
    var leftMenuView: UIView!
    var mainView:     UIView!
    var tap:          UITapGestureRecognizer!
    
    fileprivate let  BNCScreenWidth = UIScreen.main.bounds.size.width
    fileprivate let  BNCScreenHeight = UIScreen.main.bounds.size.height
    
    init (withHomePage:HomePageViewController,andWithLeft left:LeftMenuViewController) {
        super.init(nibName: nil, bundle: nil)
        self.homeViewController = withHomePage
        self.leftMenuViewController = left
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distance = 0
        leftMenuView = leftMenuViewController.view;
        leftMenuView.frame  = UIScreen.main.bounds
        leftMenuView.transform = CGAffineTransform.identity.scaledBy(x: 1,y: 1).concatenating(CGAffineTransform.identity.translatedBy(x: BNCScreenWidth * 0.6, y: 0))
        self.view.addSubview(leftMenuView)
        
        mainView = UIView.init(frame: UIScreen.main.bounds)
        mainView.addSubview(homeViewController.view)
        self.view.addSubview(mainView)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(MainViewController.pan(_:)))
        mainView.addGestureRecognizer(panGesture)
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(MainViewController.tap(_:)))
        
    }
    
    func tap(_ recongizer:UIPanGestureRecognizer) {
        showMainView()
    }
    
    func showMainView(){
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.mainView.transform = CGAffineTransform.identity
            self.leftMenuView.transform = CGAffineTransform.identity.scaledBy(x: 1,y: 1).concatenating(CGAffineTransform.identity.translatedBy(x: 0,y: 0))
            
            }, completion: { (finished)  in
                self.distance = 0
                self.mainView.removeGestureRecognizer(self.tap)
        })

    }
    
    func showLeftMenuView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.leftMenuView.transform = CGAffineTransform.identity
            self.mainView.transform = CGAffineTransform.identity.scaledBy(x: 1,y: 1).concatenating(CGAffineTransform.identity.translatedBy(x: self.BNCScreenWidth * 0.6,y: 0))
            
            }, completion: { (finished)  in
                self.distance = self.BNCScreenWidth * 0.6
                self.leftMenuView.removeGestureRecognizer(self.tap)
        })
    }
    
    func pan(_ recongizer:UIPanGestureRecognizer) {
        let moveX = recongizer.translation(in: self.view).x
        let truedistance = distance + moveX
        let percent = truedistance / (BNCScreenWidth * 0.6)
        
        if truedistance >= 0 && truedistance <= BNCScreenWidth * 0.6 {
            mainView.transform = CGAffineTransform.identity.scaledBy(x: 1,y: 1 ).concatenating(CGAffineTransform.identity.translatedBy(x: truedistance,y: 0))
            
            leftMenuView.transform = CGAffineTransform.identity.scaledBy(x: 1,y: 1).concatenating(CGAffineTransform.identity.translatedBy(x: BNCScreenWidth * 0.6 * (percent - 1),y: 0))
            
        }
        
        if recongizer.state == .ended {
            if truedistance < BNCScreenWidth * 0.3 {
                showMainView()
            } else {
                showLeftMenuView()
            }
        }

    }
    

}
