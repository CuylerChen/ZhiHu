//
//  DailyThemesViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import AlamofireImage

class DailyThemesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    var themeID: Int = 0
    var mainTableView: UITableView!
    var mainScrollView: UIScrollView!
    var imaView: UIImageView!
    var viewmodel: DailyThemesViewModel!
    
    private let  BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let  BNCScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    init() {
        super.init(nibName: nil, bundle: nil)
        themeID = 0
        viewmodel = DailyThemesViewModel.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewmodel.removeObserver(self, forKeyPath: "stories")
        viewmodel.removeObserver(self, forKeyPath: "imageURLStr")
        viewmodel.removeObserver(self, forKeyPath: "name")
        viewmodel.removeObserver(self, forKeyPath: "editors")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubViews()
        viewmodel.addObserver(self, forKeyPath: "stories", options: .New, context: nil)
        viewmodel.addObserver(self, forKeyPath: "imageURLStr", options: .New, context: nil)
        viewmodel.addObserver(self, forKeyPath: "name", options: .New, context: nil)
        viewmodel.addObserver(self, forKeyPath: "editors", options: .New, context: nil)
        viewmodel.getDailyThemesDataWithThemeID(themeID)
    }
    
    
    func initSubViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.boldSystemFontOfSize(20),NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        
        mainScrollView = UIScrollView.init(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(mainScrollView)
        
        imaView = UIImageView.init(frame: CGRectMake(0, -24, BNCScreenWidth, 122 ))
        imaView.contentMode = .ScaleAspectFill
        mainScrollView.addSubview(imaView)
        
        mainTableView = UITableView.init(frame: CGRectMake(0, 64, BNCScreenWidth, BNCScreenHeight - 64))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.rowHeight = 88
        mainTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(mainTableView)
        
        mainTableView.registerNib(UINib.init(nibName: "HomeViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "HomeViewCell")
        
        let leftBarButton = UIBarButtonItem.init(image: UIImage.init(named: "News_Arrow"), style: .Plain, target: self, action: #selector(DailyThemesViewController.back(_:) ))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage.init(named: "Dark_Management_Add"), style: .Plain, target: self, action: #selector(DailyThemesViewController.back(_:) ))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func back(sender:UIBarButtonItem ) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func attention(sender:UIBarButtonItem ) {
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "stories" {
            mainTableView.reloadData()
        }
        
        if keyPath == "imageURLStr" {
            imaView.af_setImageWithURL(NSURL.init(string: viewmodel.imageURLStr)!)
            
        }
        
        if keyPath == "name" {
            title = viewmodel.name
        }
        
        if keyPath == "editors" {
            if viewmodel.editors.count > 0 {
                let headerView = UIView.init(frame: CGRectMake(0, 0, BNCScreenWidth, 44))
                headerView.backgroundColor = UIColor.whiteColor()
                let lab = UILabel.init(frame: CGRectMake(15, 7, 40, 30))
                lab.text = "主编"
                headerView.addSubview(lab)
                for index in 0...viewmodel.editors.count - 1 {
                    let dic = viewmodel.editors[index]
                    let imaView = UIImageView.init(frame: CGRectMake( CGFloat(65 + 40 * index), 7, 30, 30))
                    imaView.af_setImageWithURL(NSURL.init(string: dic["avatar"] as! String)!)
                    imaView.layer.cornerRadius = 15
                    imaView.layer.masksToBounds = true
                    headerView.addSubview(imaView)
                }
                mainTableView.tableHeaderView = headerView
            }
        }

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if -offSetY < 48 && -offSetY > 0 {
            mainScrollView.contentOffset = CGPointMake(0, offSetY / 2)
        } else if -offSetY > 48 {
            scrollView.contentOffset = CGPointMake(0, -48)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.stories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeViewCell") as! HomeViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let story = viewmodel.stories[indexPath.row]
        cell.updateUIWithStoryModel(story)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = viewmodel.stories[indexPath.row]
        
        var storiesID = [Int]()
        for index in 0...viewmodel.stories.count {
            let id = viewmodel.stories[index].storyID
            storiesID.append(id)
        }
        
        let vm = StoryContentViewModel.init(withCurID: model.storyID, storiesID: storiesID)
        vm.type = model.type
        self.navigationItem.backBarButtonItem = nil
        self.navigationController?.pushViewController(WKWebViewController.init(WithViewModel: vm), animated: true)
        
       
    }
 
}
