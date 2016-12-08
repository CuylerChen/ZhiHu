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
    
    fileprivate let  BNCRowHeight:CGFloat = 88
    fileprivate let  BNCSectionHeaderHeight:CGFloat = 36
    fileprivate let  BNCScreenWidth = UIScreen.main.bounds.size.width
    fileprivate let  BNCScreenHeight = UIScreen.main.bounds.size.height
//    fileprivate let  cellIdentifer = "HomeViewCell"
    
    init(WithViewModel vm: HomeViewModel) {
        //super.init()
        super.init(nibName: nil, bundle: nil)
        viewmodel = vm
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageViewController.loadingLatestDaily(_:)), name: NSNotification.Name(rawValue: "LoadLatestDaily"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(HomePageViewController.loadingPreviousDaily(_:)), name: NSNotification.Name(rawValue: "LoadPreviousDaily"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageViewController.updateLatestDaily(_:)), name: NSNotification.Name(rawValue: "UpdateLatestDaily"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomePageViewController.mainScrollViewToTop(_:)), name: NSNotification.Name(rawValue: "TapStatusBar"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        mainTableView = UITableView.init(frame: CGRect(x: 0, y: 20, width: BNCScreenWidth, height: UIScreen.main.bounds.size.height - 20))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = BNCRowHeight
        mainTableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: 200))
        self.view.addSubview(mainTableView)
        
        carouseView = CarouseView.init(frame: CGRect(x: 0, y: -40, width: BNCScreenWidth, height: 260))
        carouseView.delegate = self
        carouseView.clipsToBounds = true
        self.view.addSubview(carouseView)

        navBarBackgroundView = UIView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: 56))
        navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0)
        self.view.addSubview(navBarBackgroundView)
        
        newsTodayLb = UILabel.init()
        newsTodayLb.attributedText = NSAttributedString.init(string: "今日新闻", attributes:[NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.white ])
        newsTodayLb.sizeToFit()
        newsTodayLb.center = CGPoint(x: self.view.centerX(), y: 38)
        self.view.addSubview(newsTodayLb)
        
        refreshView = RefreshView.init(frame: CGRect(x: newsTodayLb.left() - 20, y: newsTodayLb.centerY() - 10, width: 20, height: 20))
        self.view.addSubview(refreshView)
        
        let menuBtn = UIButton.init(frame: CGRect(x: 16, y: 28, width: 22, height: 22))
        menuBtn.setImage(UIImage.init(named: "Home_Icon"), for: UIControlState())
        menuBtn.addTarget(self, action: #selector(HomePageViewController.showLeftMenu), for: UIControlEvents.touchUpInside )
        self.view.addSubview(menuBtn)
        
        mainTableView.register(HomeViewCell.self, forCellReuseIdentifier: NSStringFromClass(HomeViewCell.self))
        mainTableView.register(SectionTitleView.self, forHeaderFooterViewReuseIdentifier: NSStringFromClass(SectionTitleView.self))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLeftMenu() {
        let appdele = UIApplication.shared.delegate as! AppDelegate

        appdele.mainVC.showLeftMenuView()
    }
    
    func loadingLatestDaily(_ noti:Notification) {
        let indexset = IndexSet.init(integer: 0)
        mainTableView.insertSections(indexset, with: UITableViewRowAnimation.fade)
        self.setTopStoriesContent()
    }
    
    func loadingPreviousDaily(_ noti:Notification) {
        let indexset = IndexSet.init(integer: self.viewmodel.numberOfSections() - 1)
        mainTableView.insertSections(indexset, with: UITableViewRowAnimation.fade)
    }
    
    func updateLatestDaily(_ noti:Notification) {
        if ((noti.userInfo?["isNewDay"]) != nil)  {
            if noti.userInfo?["isNewDay"] as! Bool {
                let indexset = IndexSet.init(integer: 0)
                mainTableView.reloadSections(indexset, with: UITableViewRowAnimation.fade)
                self.setTopStoriesContent()
            }
        } else {
            mainTableView.reloadData()
            self.setTopStoriesContent()
        }
    }
    
    func mainScrollViewToTop(_ noti:Notification) {
        mainTableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func setTopStoriesContent() {
        carouseView.updateUIWithTopStories(self.viewmodel.top_stories)
    }
   
    
    //MARK - CarouseViewDelegate
    func didSelectItemWithTag(_ tag: Int) {
        let story = self.viewmodel.top_stories[tag - 100]
        let vm = StoryContentViewModel.init(withCurID: story.storyID, storiesID: viewmodel.storiesID)
        let storyContentVC = StoryContentViewController.init(WithViewModel: vm)
        let appdele = UIApplication.shared.delegate as! AppDelegate
        appdele.mainVC.navigationController?.pushViewController(storyContentVC, animated: true)
    }
    
    
    //MARK - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            
            
            if -offSetY > 40 && -offSetY <= 80 && !scrollView.isDragging && !viewmodel.isLoading {
                viewmodel.updateLatestStories()
                refreshView.stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64 (2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                    self.refreshView.stopAnimation()
                    })
            }
            
            carouseView.frame = CGRect(x: 0, y: -40 - offSetY / 2,width: BNCScreenWidth, height: 260 - offSetY / 2)
            carouseView.updateSubViewsOriginY(offSetY)
            navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0)
            } else if offSetY < -80 {
                mainTableView.contentOffset = CGPoint(x: 0, y: -80)
            } else if offSetY <= 300 {
                refreshView.redrawFromProgress(0)
                carouseView.frame = CGRect(x: 0, y: -40 - offSetY, width: BNCScreenWidth, height: 260)
                navBarBackgroundView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: offSetY / (220 - 56))
            }
            
            //上拉刷新
            if offSetY + BNCRowHeight > mainTableView.contentSize.height - UIScreen.main.bounds.size.height {
                if !viewmodel.isLoading {
                    viewmodel.getPreviousStories()
                    return
                }
            }

        }
    }
    
    // MARK UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberOfRowsInSection(section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewmodel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell.init()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(HomeViewCell.self), for: indexPath) as! HomeViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let story = viewmodel.storyAtIndexPath(indexPath)
        cell.updateUIWithStoryModel(story)
        return cell
    }
    
    
    
    // MARK - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = viewmodel.storyAtIndexPath(indexPath)
        let vm = StoryContentViewModel.init(withCurID: story.storyID, storiesID: viewmodel.storiesID)
        vm.getStoryContentWithStoryID(story.storyID)
        let storyContentVC = StoryContentViewController.init(WithViewModel: vm)
        let appdele = UIApplication.shared.delegate as! AppDelegate
        appdele.mainVC.navigationController?.pushViewController(storyContentVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return BNCSectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: NSStringFromClass(SectionTitleView.self)) as! SectionTitleView
        headerView.contentView.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 1)
        headerView.textLabel?.attributedText = viewmodel.titleForSection(section)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            navBarBackgroundView.setHeight(56)
            newsTodayLb.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            navBarBackgroundView.setHeight(20)
            newsTodayLb.alpha = 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
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
