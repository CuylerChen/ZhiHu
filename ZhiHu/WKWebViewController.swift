//
//  WKWebViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import WebKit

class WKWebViewController: UIViewController {
    var viewmodel: StoryContentViewModel!
    var webView: WKWebView!
    
    private let  BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let  BNCScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    init(WithViewModel:StoryContentViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewmodel = WithViewModel
        viewmodel.addObserver(self, forKeyPath: "storyModel", options: .New, context: nil)
        viewmodel.getStoryContentWithStoryID(WithViewModel.loadedStoryID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewmodel.removeObserver(self, forKeyPath: "storyModel")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initSubViews()
    }
    
    func initSubViews() {
        webView = WKWebView.init(frame: CGRectMake(0, 0, BNCScreenWidth, BNCScreenHeight - 43))
        self.view.addSubview(webView)
      
        let navBar = UIView.init(frame: CGRectMake(0, 0, BNCScreenWidth, 64))
        navBar.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0)

        self.view.addSubview(navBar)
        
        let toolBar = UIView.init(frame: CGRectMake(0, BNCScreenHeight - 43, BNCScreenWidth, 43))
        let backBtn = UIButton.init(frame: CGRectMake(0, 0, BNCScreenWidth / 5, 43))
        backBtn.setImage(UIImage.init(named: "News_Navigation_Arrow"), forState: .Normal )
        backBtn.addTarget(self, action: #selector(StoryContentViewController.backAction(_:)), forControlEvents: .TouchUpInside)
        toolBar.addSubview(backBtn)
        
        let nextBtn = UIButton.init(frame: CGRectMake(BNCScreenWidth / 5, 0, BNCScreenWidth / 5, 43))
        nextBtn.setImage(UIImage.init(named: "News_Navigation_Next"), forState: .Normal )
        nextBtn.addTarget(self, action: #selector(StoryContentViewController.nextStoryAction(_:)), forControlEvents: .TouchUpInside)
        toolBar.addSubview(nextBtn)
        
        let votedBtn = UIButton.init(frame: CGRectMake(BNCScreenWidth / 5 * 2 , 0, BNCScreenWidth / 5, 43))
        votedBtn.setImage(UIImage.init(named: "News_Navigation_Voted"), forState: .Normal )
        toolBar.addSubview(votedBtn)
        
        let sharedBtn = UIButton.init(frame: CGRectMake(BNCScreenWidth / 5 * 3 , 0, BNCScreenWidth / 5, 43))
        sharedBtn.setImage(UIImage.init(named: "News_Navigation_Share"), forState: .Normal )
        toolBar.addSubview(sharedBtn)
        
        let commentdBtn = UIButton.init(frame: CGRectMake(BNCScreenWidth / 5 * 4, 0, BNCScreenWidth / 5, 43))
        commentdBtn.setImage(UIImage.init(named: "News_Navigation_Comment"), forState: .Normal )
        toolBar.addSubview(commentdBtn)
        
        self.view.addSubview(toolBar)
    }
    
    func backAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func nextStoryAction(sender: UIButton) {
        viewmodel.getNextStoryContent()
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
       
        if keyPath == "storyModel" {
            
            webView.loadRequest(NSURLRequest.init(URL: NSURL.init(string: viewmodel.share_URL())!))
        }
    }
}
