//
//  LeftMenuViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import Alamofire

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    var subscribedList: [ThemeItemModel]! = []
    var othersList: [ThemeItemModel]! = []
    var themeItems: [ThemeItemModel]! = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        subscribedList = []
        othersList = []
        themeItems = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getThemeList()  
    }
    
    func getThemeList() {
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/themes")
            .responseJSON { response in
                if let JSON = response.result.value {
                    let  subArr = JSON["subscribed"] as! [[String:AnyObject]]
                    for dic in subArr {
                        let model = ThemeItemModel.init(withDictionary: dic)
                        self.subscribedList.append(model)
                    }
                    
                    let othArr = JSON["others"] as! [[String:AnyObject]]
                    for dic in othArr {
                        let model = ThemeItemModel.init(withDictionary: dic)
                        self.othersList.append(model)
                    }
                    self.setMentItems()
                }
        }
    }
    
    func setMentItems() {
        mainScrollView.contentSize = CGSizeMake(0, CGFloat(1 + subscribedList.count + othersList.count ) * 44)
        let homeItem = NSBundle.mainBundle().loadNibNamed("TMItemView", owner: self, options: nil).first as! TMItemView
        
        homeItem.frame = CGRectMake(0, 0, mainScrollView.width(), 44)
        homeItem.menuTitleLb.text = "首页";
        homeItem.menuImaView.image = UIImage.init(named: "Menu_Icon_Home")
        homeItem.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(LeftMenuViewController.showHome(_:))))
        mainScrollView.addSubview(homeItem)
        
        var tempHeight = homeItem.height()
        themeItems.appendContentsOf(subscribedList)
        themeItems.appendContentsOf(othersList)
        for index in 0...themeItems.count - 1 {
            let itemView = NSBundle.mainBundle().loadNibNamed("TMItemView", owner: self, options: nil).first as! TMItemView
            itemView.frame = CGRectMake(0 , tempHeight, mainScrollView.width(),44)
            itemView.menuImaView.removeFromSuperview()
            itemView.addConstraints([NSLayoutConstraint.init(item: itemView.menuTitleLb, attribute: .Leading, relatedBy: .Equal, toItem: itemView, attribute: .Leading, multiplier: 1, constant: 4)])
            
            let model = themeItems[index]
            itemView.menuTitleLb.text = model.name
            itemView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(LeftMenuViewController.didSelectedMenuItem(_:))))
            itemView.tag = index
            mainScrollView.addSubview(itemView)
            tempHeight += 44
        }
        
    }
    

    func showHome(recognizer :UIGestureRecognizer) {
        let appdele = UIApplication.sharedApplication().delegate as! AppDelegate
        appdele.mainVC.showMainView()
    }
    
    func didSelectedMenuItem(recognizer :UIGestureRecognizer) {
        let model = themeItems[(recognizer.view?.tag)!] 
        let dailyThemeVC = DailyThemesViewController.init()
        dailyThemeVC.themeID = model.themeID
        let subNavigationVC = UINavigationController.init(rootViewController: dailyThemeVC)
        let appdele = UIApplication.sharedApplication().delegate as! AppDelegate
        appdele.mainVC.presentViewController(subNavigationVC, animated: true, completion: nil)

    }
}
