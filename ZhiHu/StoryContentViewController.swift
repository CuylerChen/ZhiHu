//
//  StoryContentViewController.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import AlamofireImage
import WebKit

class StoryContentViewController: UIViewController,UIScrollViewDelegate {

    var imageView:  UIImageView!
    var headerView: UIView!
    var titleLab: UILabel!
    var imaSourceLab: UILabel!
    var webView:      WKWebView!
    var preView: PreView!
    var viewmodel: StoryContentViewModel!
    
    fileprivate let  BNCScreenWidth = UIScreen.main.bounds.size.width
    fileprivate let  BNCScreenHeight = UIScreen.main.bounds.size.height
    
    init(WithViewModel: StoryContentViewModel) {
        super.init(nibName: nil, bundle: nil)
        viewmodel = WithViewModel
        viewmodel.addObserver(self, forKeyPath: "storyModel", options: .new, context: nil)
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
        webView = WKWebView.init(frame: CGRect(x: 0, y: 20, width: BNCScreenWidth, height: BNCScreenHeight - 63))
        webView.scrollView.delegate = self
        webView.backgroundColor = UIColor.white
        self.view.addSubview(webView)
        
        headerView = UIView.init(frame: CGRect(x: 0, y: -40, width: BNCScreenWidth, height: 260))
        headerView.clipsToBounds = true
        self.view.addSubview(headerView)
        
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: BNCScreenWidth, height: 300))
        imageView.contentMode = .scaleAspectFill
        headerView.addSubview(imageView)
        
        titleLab = UILabel.init(frame: CGRect.zero)
        titleLab.numberOfLines = 0
        headerView.addSubview(titleLab)
        
        
        imaSourceLab = UILabel.init(frame: CGRect(x: 10, y: 240, width: BNCScreenWidth - 20, height: 20))
        imaSourceLab.textAlignment = .right
        imaSourceLab.font = UIFont.systemFont(ofSize: 12)
        imaSourceLab.textColor = UIColor.white
        headerView.addSubview(imaSourceLab)
        
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
        
        preView = PreView.init(frame: UIScreen.main.bounds)
        self.view.addSubview(preView)
        
    }
    
    func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func nextStoryAction(_ sender: UIButton) {
        viewmodel.getNextStoryContent()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        if -offSetY <= 80 && -offSetY >= 0 {
            headerView.frame = CGRect(x: 0, y: -40 - offSetY / 2, width: BNCScreenWidth, height: 260 - offSetY / 2)
            imaSourceLab.setTop(240 - offSetY / 2)
            titleLab.setBottom(imaSourceLab.bottom() - 20)
            if -offSetY > 40 && !webView.scrollView.isDragging {
                viewmodel.getPreviousStoryContent()
            }
        } else if -offSetY > 80 {
            webView.scrollView.contentOffset = CGPoint(x: 0 , y: -80)
        } else if offSetY <= 300 {
            headerView.frame = CGRect(x: 0, y: -40 - offSetY, width: BNCScreenWidth, height: 260)
        }
        
        if offSetY + BNCScreenHeight > scrollView.contentSize.height + 160 && !webView.scrollView.isDragging {
            viewmodel.getNextStoryContent()
        }
    }
    
    func loadNewPages(_ noti:Notification) {
        imageView.af_setImage(withURL: URL.init(string: viewmodel.ImageURLString())!)
        let size = viewmodel.titleAttText().boundingRect(with: CGSize(width: BNCScreenWidth - 30, height: 60), options: NSStringDrawingOptions.usesLineFragmentOrigin.union(NSStringDrawingOptions.usesFontLeading), context: nil).size
        titleLab.frame = CGRect(x: 15, y: headerView.frame.size.height - 20 - size.height, width: BNCScreenWidth - 30, height: size.height)
        titleLab.attributedText = viewmodel.titleAttText()
        imaSourceLab.text = viewmodel.imaSourceText()
        webView.loadHTMLString(viewmodel.htmlStr(), baseURL: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64 (1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            self.preView.removeFromSuperview()
        })

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "storyModel" {
            imageView.af_setImage(withURL: URL.init(string: viewmodel.ImageURLString() )!)
            let size = viewmodel.titleAttText().boundingRect(with: CGSize(width: BNCScreenWidth - 30, height: 60), options: NSStringDrawingOptions.usesLineFragmentOrigin.union(NSStringDrawingOptions.usesFontLeading), context: nil).size
            titleLab.frame = CGRect(x: 15, y: headerView.frame.size.height - 20 - size.height, width: BNCScreenWidth - 30, height: size.height)
            titleLab.attributedText = viewmodel.titleAttText()
            imaSourceLab.text = viewmodel.imaSourceText()
            webView.loadHTMLString(viewmodel.htmlStr(), baseURL: nil)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64 (1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                self.preView.removeFromSuperview()
            })

        }
    }

}

