//
//  StoryContentViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import AlamofireImage

class StoryContentViewController: UIViewController,UIScrollViewDelegate {

    var imageView:  UIImageView!
    var headerView: UIView!
    var titleLab: UILabel!
    var imaSourceLab: UILabel!
    var webView:      UIWebView!
    var preView: PreView!
    var viewmodel: StoryContentViewModel!
    
    private let  BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    private let  BNCScreenHeight = UIScreen.mainScreen().bounds.size.height
    
    init(WithViewModel: StoryContentViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewmodel = WithViewModel
        viewmodel.addObserver(self, forKeyPath: "storyModel", options: .New, context: nil)
        viewmodel.getStoryContentWithStoryID(WithViewModel.loadedStoryID)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StoryContentViewController.loadNewPages(_:)), name: "loadNewPages", object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        viewmodel.removeObserver(self, forKeyPath: "storyModel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubviews()
    }
    
    func initSubviews() {
        
        self.automaticallyAdjustsScrollViewInsets = false
        webView = UIWebView.init(frame: CGRectMake(0, 20, BNCScreenWidth, BNCScreenHeight - 63))
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(webView)
        
        headerView = UIView.init(frame: CGRectMake(0, -40, BNCScreenWidth, 260))
        headerView.clipsToBounds = true
        self.view.addSubview(headerView)
        
        imageView = UIImageView.init(frame: CGRectMake(0, 0, BNCScreenWidth, 300))
        imageView.contentMode = .ScaleAspectFill
        headerView.addSubview(imageView)
        
        titleLab = UILabel.init(frame: CGRectZero)
        titleLab.numberOfLines = 0
        headerView.addSubview(titleLab)
        
        
        imaSourceLab = UILabel.init(frame: CGRectMake(10, 240, BNCScreenWidth - 20, 20))
        imaSourceLab.textAlignment = .Right
        imaSourceLab.font = UIFont.systemFontOfSize(12)
        imaSourceLab.textColor = UIColor.whiteColor()
        headerView.addSubview(imaSourceLab)
        
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
        
        preView = PreView.init(frame: UIScreen.mainScreen().bounds)
        self.view.addSubview(preView)
        
    }
    
    func backAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func nextStoryAction(sender: UIButton) {
        viewmodel.getNextStoryContent()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if -offSetY <= 80 && -offSetY >= 0 {
            headerView.frame = CGRectMake(0, -40 - offSetY / 2, BNCScreenWidth, 260 - offSetY / 2)
            imaSourceLab.setTop(240 - offSetY / 2)
            titleLab.setBottom(imaSourceLab.bottom() - 20)
            if -offSetY > 40 && !webView.scrollView.dragging {
                viewmodel.getPreviousStoryContent()
            }
        } else if -offSetY > 80 {
            webView.scrollView.contentOffset = CGPointMake(0 , -80)
        } else if offSetY <= 300 {
            headerView.frame = CGRectMake(0, -40 - offSetY, BNCScreenWidth, 260)
        }
        
        if offSetY + BNCScreenHeight > scrollView.contentSize.height + 160 && !webView.scrollView.dragging {
            viewmodel.getNextStoryContent()
        }
    }
    
    func loadNewPages(noti:NSNotification) {
        imageView.af_setImageWithURL(NSURL.init(string: viewmodel.ImageURLString())!)
        let size = viewmodel.titleAttText().boundingRectWithSize(CGSizeMake(BNCScreenWidth - 30, 60), options: NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading), context: nil).size
        titleLab.frame = CGRectMake(15, headerView.frame.size.height - 20 - size.height, BNCScreenWidth - 30, size.height)
        titleLab.attributedText = viewmodel.titleAttText()
        imaSourceLab.text = viewmodel.imaSourceText()
        webView.loadHTMLString(viewmodel.htmlStr(), baseURL: nil)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64 (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.preView.removeFromSuperview()
        })

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "storyModel" {
            imageView.af_setImageWithURL(NSURL.init(string: viewmodel.ImageURLString())!)
            let size = viewmodel.titleAttText().boundingRectWithSize(CGSizeMake(BNCScreenWidth - 30, 60), options: NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading), context: nil).size
            titleLab.frame = CGRectMake(15, headerView.frame.size.height - 20 - size.height, BNCScreenWidth - 30, size.height)
            titleLab.attributedText = viewmodel.titleAttText()
            imaSourceLab.text = viewmodel.imaSourceText()
            webView.loadHTMLString(viewmodel.htmlStr(), baseURL: nil)
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64 (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.preView.removeFromSuperview()
            })

        }
    }

}

