//
//  HomePageViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import Alamofire

class HomePageViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,CarouseViewDelegate {
    
    var  mainTableView: UITableView!
    var  navBarBackgroundView: UIView!
    var  newsTodayLb: UILabel!
    var  storyModel: [StoryModel] = []
    var  refreshView: RefreshView!
    var  viewmodel: HomeViewModel!
    var  carouseView: CarouseView!
    
    private let  BNCRowHeight:CGFloat = 88
    private let  BNCSectionHeaderHeight:CGFloat = 36
    private let  BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let  BNCScreenHeight = UIScreen.mainScreen().bounds.size.height
    private let  cellIdentifer = "HomeViewCell"
    
    init(WithViewModel vm: HomeViewModel) {
        //super.init()
        super.init(nibName: nil, bundle: nil)
        viewmodel = vm
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomePageViewController.loadingLatestDaily(_:)), name: "LoadLatestDaily", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(HomePageViewController.loadingPreviousDaily(_:)), name: "LoadPreviousDaily", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomePageViewController.updateLatestDaily(_:)), name: "UpdateLatestDaily", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomePageViewController.mainScrollViewToTop(_:)), name: "TapStatusBar", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubView()
        viewmodel.getLatestStories()
    }
    
    func initSubView() {
        mainTableView = UITableView.init(frame: CGRectMake(0, 20, BNCScreenWidth, UIScreen.mainScreen().bounds.size.height - 20))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = BNCRowHeight
        mainTableView.tableHeaderView = UIView.init(frame: CGRectMake(0, 0, BNCScreenWidth, 200))
        self.view.addSubview(mainTableView)
        
        carouseView = CarouseView.init(frame: CGRectMake(0, -40, BNCScreenWidth, 260))
        carouseView.delegate = self
        carouseView.clipsToBounds = true
        self.view.addSubview(carouseView)

        navBarBackgroundView = UIView.init(frame: CGRectMake(0, 0, BNCScreenWidth, 56))
        navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0)
        self.view.addSubview(navBarBackgroundView)
        
        newsTodayLb = UILabel.init()
        newsTodayLb.attributedText = NSAttributedString.init(string: "今日新闻", attributes:[NSFontAttributeName:UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName:UIColor.whiteColor() ])
        newsTodayLb.sizeToFit()
        newsTodayLb.center = CGPointMake(self.view.centerX(), 38)
        self.view.addSubview(newsTodayLb)
        
        refreshView = RefreshView.init(frame: CGRectMake(newsTodayLb.left() - 20, newsTodayLb.centerY() - 10, 20, 20))
        self.view.addSubview(refreshView)
        
        let menuBtn = UIButton.init(frame: CGRectMake(16, 28, 22, 22))
        menuBtn.setImage(UIImage.init(named: "Home_Icon"), forState: UIControlState.Normal)
        menuBtn.addTarget(self, action: #selector(HomePageViewController.showLeftMenu), forControlEvents: UIControlEvents.TouchUpInside )
        self.view.addSubview(menuBtn)
        
        mainTableView.registerNib(UINib.init(nibName: cellIdentifer, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: cellIdentifer)
        mainTableView.registerClass(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(SectionTitleView.self))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLeftMenu() {
        let appdele = UIApplication.sharedApplication().delegate as! AppDelegate

        appdele.mainVC.showLeftMenuView()
    }
    
    func loadingLatestDaily(noti:NSNotification) {
        let indexset = NSIndexSet.init(index: 0)
        mainTableView.insertSections(indexset, withRowAnimation: UITableViewRowAnimation.Fade)
        self.setTopStoriesContent()
    }
    
    func loadingPreviousDaily(noti:NSNotification) {
        let indexset = NSIndexSet.init(index: self.viewmodel.numberOfSections() - 1)
        mainTableView.insertSections(indexset, withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func updateLatestDaily(noti:NSNotification) {
        if ((noti.userInfo?["isNewDay"]) != nil)  {
            if noti.userInfo?["isNewDay"] as! Bool {
                let indexset = NSIndexSet.init(index: 0)
                mainTableView.reloadSections(indexset, withRowAnimation: UITableViewRowAnimation.Fade)
                self.setTopStoriesContent()
            }
        } else {
            mainTableView.reloadData()
            self.setTopStoriesContent()
        }
    }
    
    func mainScrollViewToTop(noti:NSNotification) {
        mainTableView.setContentOffset(CGPointZero, animated: true)
    }
    
    func setTopStoriesContent() {
        carouseView.updateUIWithTopStories(self.viewmodel.top_stories)
    }
   
    
    //MARK - CarouseViewDelegate
    func didSelectItemWithTag(tag: Int) {
        let story = self.viewmodel.top_stories[tag - 100]
        let vm = StoryContentViewModel.init(withCurID: story.storyID, storiesID: viewmodel.storiesID)
        let storyContentVC = StoryContentViewController.init(WithViewModel: vm)
        let appdele = UIApplication.sharedApplication().delegate as! AppDelegate
        appdele.mainVC.navigationController?.pushViewController(storyContentVC, animated: true)
    }
    
    
    //MARK - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.isEqual(self.mainTableView) {
            let offSetY = scrollView.contentOffset.y
            if offSetY <= 0 && offSetY >= -80 {
                if offSetY >= -40 {
                    if viewmodel.isLoading == false {
                        refreshView.redrawFromProgress(-offSetY / 40)
                    } else {
                        refreshView.redrawFromProgress(0)
                    }
                }
            
            
            if -offSetY > 40 && -offSetY <= 80 && !scrollView.dragging && !viewmodel.isLoading {
                viewmodel.updateLatestStories()
                refreshView.stopAnimation()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64 (2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                    self.refreshView.stopAnimation()
                    })
            }
            
            carouseView.frame = CGRectMake(0, -40 - offSetY / 2,BNCScreenWidth, 260 - offSetY / 2)
            carouseView.updateSubViewsOriginY(offSetY)
            navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0)
            } else if offSetY < -80 {
                mainTableView.contentOffset = CGPointMake(0, -80)
            } else if offSetY <= 300 {
                refreshView.redrawFromProgress(0)
                carouseView.frame = CGRectMake(0, -40 - offSetY, BNCScreenWidth, 260)
                navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: offSetY / (220 - 56))
            }
            
            //上拉刷新
            if offSetY + BNCRowHeight > mainTableView.contentSize.height - UIScreen.mainScreen().bounds.size.height {
                if !viewmodel.isLoading {
                    viewmodel.getPreviousStories()
                    return
                }
            }

        }
    }
    
    // MARK UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberOfRowsInSection(section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewmodel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as! HomeViewCell

        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer)! as! HomeViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let story = viewmodel.storyAtIndexPath(indexPath)
        cell.updateUIWithStoryModel(story)
        return cell
    }
    
    // MARK - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let story = viewmodel.storyAtIndexPath(indexPath)
        let vm = StoryContentViewModel.init(withCurID: story.storyID, storiesID: viewmodel.storiesID)
        vm.getStoryContentWithStoryID(story.storyID)
        let storyContentVC = StoryContentViewController.init(WithViewModel: vm)
        let appdele = UIApplication.sharedApplication().delegate as! AppDelegate
        appdele.mainVC.navigationController?.pushViewController(storyContentVC, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return BNCSectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(NSStringFromClass(SectionTitleView.self)) as! SectionTitleView
        headerView.contentView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 1)
        headerView.textLabel?.attributedText = viewmodel.titleForSection(section)
        return headerView
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            navBarBackgroundView.setHeight(56)
            newsTodayLb.alpha = 1
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            navBarBackgroundView.setHeight(20)
            newsTodayLb.alpha = 0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
