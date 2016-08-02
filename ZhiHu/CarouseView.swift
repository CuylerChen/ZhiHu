//
//  CarouseView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import AlamofireImage

protocol CarouseViewDelegate: NSObjectProtocol {
    func didSelectItemWithTag(tag: Int)
}

class CarouseView: UIView,UIScrollViewDelegate {
    var topStories:[StoryModel] = []
    weak var delegate: CarouseViewDelegate?
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var timer: NSTimer!
    
    private let BNCScreenWidth = UIScreen.mainScreen().bounds.size.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 300))
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * 7,0)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        var i:CGFloat = 0.0
        
        for index in 0...6 {
            
            let tsv = TopStoryView.init(frame: CGRectMake(BNCScreenWidth * i ,0,BNCScreenWidth ,300) )
            tsv.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CarouseView.tap(_:))))
            tsv.tag = index + 100
            scrollView.addSubview(tsv)
            i += 1
        }
        pageControl = UIPageControl.init(frame: CGRectMake(0, 240, BNCScreenWidth, 20))
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.addSubview(pageControl)
        
    }
    
    func viewWillDisappear() {
        timer.invalidate()
    }
    
    
    func tap(recognizer:UIGestureRecognizer ) {
        self.delegate?.didSelectItemWithTag((recognizer.view?.tag)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUIWithTopStories(stories:[StoryModel]) {
        topStories = stories
        pageControl.numberOfPages = topStories.count - 2
        scrollView.contentOffset = CGPointMake(BNCScreenWidth, 0)
        pageControl.currentPage = 0
        
        for index in 0...topStories.count - 1 {
            let tsv = scrollView.viewWithTag(100 + index) as! TopStoryView
            let model = topStories[index]
            tsv.imageView.af_setImageWithURL(NSURL.init(string: model.image)!)
            let attStr = NSAttributedString.init(string: model.title, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(21),NSForegroundColorAttributeName:UIColor.whiteColor()])
            let size = attStr.boundingRectWithSize(CGSizeMake(BNCScreenWidth - 30, 200), options: NSStringDrawingOptions.UsesLineFragmentOrigin.union(NSStringDrawingOptions.UsesFontLeading), context: nil).size
            tsv.label.frame = CGRectMake(15, 0, BNCScreenWidth, size.height)
            tsv.label.setBottom(240)
            tsv.label.attributedText = attStr
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(CarouseView.nextStoryDisplay), userInfo: nil, repeats: true)
    }
    
    func nextStoryDisplay() {
        scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x + BNCScreenWidth, 0), animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offSetX = scrollView.contentOffset.x
            if offSetX == 6 * BNCScreenWidth {
                self.scrollView.contentOffset = CGPointMake(BNCScreenWidth, 0)
                self.pageControl.currentPage = 0
            } else if offSetX == 0 {
                self.scrollView.contentOffset = CGPointMake(BNCScreenWidth * 5, 0)
                self.pageControl.currentPage = 4
            } else {
                self.pageControl.currentPage = Int(offSetX / BNCScreenWidth ) - 1

            }
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        timer.fireDate = NSDate.init(timeIntervalSinceNow: 5)
    }
    
    func updateSubViewsOriginY(value: CGFloat) {
        pageControl.setBottom(260 - value / 2)
        let index = Int(scrollView.contentOffset.x / BNCScreenWidth)
        let tsv = scrollView.viewWithTag(index + 100) as! TopStoryView
        tsv.label.setBottom(pageControl.top())
    }
    
}
