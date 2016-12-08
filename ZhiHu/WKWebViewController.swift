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
    
    fileprivate let  BNCScreenWidth = UIScreen.main.bounds.size.width
    fileprivate let  BNCScreenHeight = UIScreen.main.bounds.size.height
    
    init(WithViewModel:StoryContentViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewmodel = WithViewModel
        viewmodel.addObserver(self, forKeyPath: "storyModel", options: .new, context: nil)
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

        webView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: BNCScreenHeight - 43))
        self.view.addSubview(webView)
      
        let navBar = UIView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: 64))
        navBar.backgroundColor = UIColor.init(red: 60 / 255, green: 198 / 255, blue: 253 / 255, alpha: 0.8)

        self.view.addSubview(navBar)
        
        let toolBar = UIView.init(frame: CGRect(x: 0, y: BNCScreenHeight - 43, width: BNCScreenWidth, height: 43))
        let backBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth / 5, height: 43))
        backBtn.setImage(UIImage.init(named: "News_Navigation_Arrow"), for: UIControlState() )
        backBtn.addTarget(self, action: #selector(StoryContentViewController.backAction(_:)), for: .touchUpInside)
        toolBar.addSubview(backBtn)
        
        let nextBtn = UIButton.init(frame: CGRect(x: BNCScreenWidth / 5, y: 0, width: BNCScreenWidth / 5, height: 43))
        nextBtn.setImage(UIImage.init(named: "News_Navigation_Next"), for: UIControlState() )
        nextBtn.addTarget(self, action: #selector(StoryContentViewController.nextStoryAction(_:)), for: .touchUpInside)
        toolBar.addSubview(nextBtn)
        
        let votedBtn = UIButton.init(frame: CGRect(x: BNCScreenWidth / 5 * 2 , y: 0, width: BNCScreenWidth / 5, height: 43))
        votedBtn.setImage(UIImage.init(named: "News_Navigation_Voted"), for: UIControlState() )
        toolBar.addSubview(votedBtn)
        
        let sharedBtn = UIButton.init(frame: CGRect(x: BNCScreenWidth / 5 * 3 , y: 0, width: BNCScreenWidth / 5, height: 43))
        sharedBtn.setImage(UIImage.init(named: "News_Navigation_Share"), for: UIControlState() )
        toolBar.addSubview(sharedBtn)
        
        let commentdBtn = UIButton.init(frame: CGRect(x: BNCScreenWidth / 5 * 4, y: 0, width: BNCScreenWidth / 5, height: 43))
        commentdBtn.setImage(UIImage.init(named: "News_Navigation_Comment"), for: UIControlState() )
        toolBar.addSubview(commentdBtn)
        
        self.view.addSubview(toolBar)
    }
    
    func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nextStoryAction(_ sender: UIButton) {
        viewmodel.getNextStoryContent()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
       
        if keyPath == "storyModel" {
            webView.load(URLRequest.init(url: URL.init(string: viewmodel.share_URL())!))
        }
    }
}
