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
    func didSelectItemWithTag(_ tag: Int)
}

class CarouseView: UIView,UIScrollViewDelegate {
    var topStories:[StoryModel] = []
    weak var delegate: CarouseViewDelegate?
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var timer: Timer!
    
    fileprivate let BNCScreenWidth = UIScreen.main.bounds.size.width
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * 7,height: 0)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        var i:CGFloat = 0.0
        
        for index in 0...6 {
            
            let tsv = TopStoryView.init(frame: CGRect(x: BNCScreenWidth * i ,y: 0,width: BNCScreenWidth ,height: 300) )
            tsv.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(CarouseView.tap(_:))))
            tsv.tag = index + 100
            scrollView.addSubview(tsv)
            i += 1
        }
        pageControl = UIPageControl.init(frame: CGRect(x: 0, y: 240, width: BNCScreenWidth, height: 20))
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.gray
        self.addSubview(pageControl)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CarouseView.nextStoryDisplay), userInfo: nil, repeats: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarouseView.TimerPause), name: NSNotification.Name(rawValue: "CarouseViewTimerPause"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarouseView.TimerRestore), name: NSNotification.Name(rawValue: "CarouseViewTimerRestore"), object: nil)
        
    }
    
    func  TimerPause() {
        if timer.isValid {
             timer.fireDate = Date.distantFuture
        }
    }
    
    func TimerRestore() {
        if timer.isValid {
            timer.fireDate = Date.distantPast
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func tap(_ recognizer:UIGestureRecognizer ) {
        self.delegate?.didSelectItemWithTag((recognizer.view?.tag)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUIWithTopStories(_ stories:[StoryModel]) {
        topStories = stories
        pageControl.numberOfPages = topStories.count - 2
        scrollView.contentOffset = CGPoint(x: BNCScreenWidth, y: 0)
        pageControl.currentPage = 0
        
        for index in 0...topStories.count - 1 {
            let tsv = scrollView.viewWithTag(100 + index) as! TopStoryView
            let model = topStories[index]
            tsv.imageView.af_setImage(withURL: URL.init(string: model.image)! )
            
            let attStr = NSAttributedString.init(string: model.title, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 21),NSForegroundColorAttributeName:UIColor.white])
            let size = attStr.boundingRect(with: CGSize(width: BNCScreenWidth - 30, height: 200), options: NSStringDrawingOptions.usesLineFragmentOrigin.union(NSStringDrawingOptions.usesFontLeading), context: nil).size
            tsv.label.frame = CGRect(x: 15, y: 0, width: BNCScreenWidth, height: size.height)
            tsv.label.setBottom(240)
            tsv.label.attributedText = attStr
        }
        
        
        
    }
    
    func nextStoryDisplay() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + BNCScreenWidth, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            let offSetX = scrollView.contentOffset.x
            if offSetX == 6 * BNCScreenWidth {
                self.scrollView.contentOffset = CGPoint(x: BNCScreenWidth, y: 0)
                self.pageControl.currentPage = 0
            } else if offSetX == 0 {
                self.scrollView.contentOffset = CGPoint(x: BNCScreenWidth * 5, y: 0)
                self.pageControl.currentPage = 4
            } else {
                self.pageControl.currentPage = Int(offSetX / BNCScreenWidth ) - 1

            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        timer.fireDate = Date.init(timeIntervalSinceNow: 5)
    }
    
    func updateSubViewsOriginY(_ value: CGFloat) {
        pageControl.setBottom(260 - value / 2)
        let index = Int(scrollView.contentOffset.x / BNCScreenWidth)
        let tsv = scrollView.viewWithTag(index + 100) as! TopStoryView
        tsv.label.setBottom(pageControl.top())
    }
    
}
