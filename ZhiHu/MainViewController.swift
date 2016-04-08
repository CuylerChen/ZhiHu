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
    
    private let  BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let  BNCScreenHeight = UIScreen.mainScreen().bounds.size.height
    
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
        leftMenuView.frame  = UIScreen.mainScreen().bounds
        leftMenuView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity,1,1),CGAffineTransformTranslate(CGAffineTransformIdentity, BNCScreenWidth * 0.6, 0))
        self.view.addSubview(leftMenuView)
        
        mainView = UIView.init(frame: UIScreen.mainScreen().bounds)
        mainView.addSubview(homeViewController.view)
        self.view.addSubview(mainView)
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(MainViewController.pan(_:)))
        mainView.addGestureRecognizer(panGesture)
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(MainViewController.tap(_:)))
        
    }
    
    func tap(recongizer:UIPanGestureRecognizer) {
        showMainView()
    }
    
    func showMainView(){
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.mainView.transform = CGAffineTransformIdentity
            self.leftMenuView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity,1,1),CGAffineTransformTranslate(CGAffineTransformIdentity,0,0))
            
            }, completion: { (finished)  in
               self.distance = 0
                self.mainView.removeGestureRecognizer(self.tap)
        })

    }
    
    func showLeftMenuView() {
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.leftMenuView.transform = CGAffineTransformIdentity
            self.mainView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity,1,1),CGAffineTransformTranslate(CGAffineTransformIdentity,self.BNCScreenWidth * 0.6,0))
            
            }, completion: { (finished)  in
                self.distance = self.BNCScreenWidth * 0.6
                self.leftMenuView.removeGestureRecognizer(self.tap)
        })
    }
    
    func pan(recongizer:UIPanGestureRecognizer) {
        let moveX = recongizer.translationInView(self.view).x
        let truedistance = distance + moveX
        let percent = truedistance / (BNCScreenWidth * 0.6)
        
        if truedistance >= 0 && truedistance <= BNCScreenWidth * 0.6 {
            mainView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity,1,1 ),CGAffineTransformTranslate(CGAffineTransformIdentity,truedistance,0))
            
            leftMenuView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity,1,1),
            CGAffineTransformTranslate(CGAffineTransformIdentity,   BNCScreenWidth * 0.6 * (percent - 1),0))
            
        }
        
        if recongizer.state == .Ended {
            if truedistance < BNCScreenWidth * 0.3 {
                showMainView()
            } else {
                showLeftMenuView()
            }
        }

    }
    

}
