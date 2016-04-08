//
//  HomeViewModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/7.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import Alamofire

class SectionViewModel: NSObject {
    var sectionTitleText: String! = ""
    var sectionDataSource: [StoryModel]! = []
    
    init(withDictionary dic : [String:AnyObject]) {
        super.init()
        sectionTitleText = self.stringConvertToSectionTitleText(dic["date"] as! String)
        let  stories = dic["stories"] as! [AnyObject]
        for story in stories  {
            let model = StoryModel.init(withDictionary: story as! [String : AnyObject])
            sectionDataSource.append(model)
        }
    }

    func stringConvertToSectionTitleText(str:String) -> String {
        let formatter = NSDateFormatter.sharedInstance
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.dateFromString(str)
        formatter.locale = NSLocale.init(localeIdentifier: "zh-CH")
        formatter.dateFormat = "MM月dd日 EEEE"
        let sectionTitleText = formatter.stringFromDate(date!)
        return sectionTitleText
        
    }
    
}

class HomeViewModel: NSObject {
    var daysDataList: [SectionViewModel]! = []
    var top_stories: [StoryModel]! = []
    var isLoading: Bool = false
    var storiesID: [Int]! = []
    var currentLoadDayStr: String! = ""
    
    override init() {
        daysDataList = []
        top_stories = []
        isLoading = false
        storiesID = []
        currentLoadDayStr = ""
    }
    
    
    
    func numberOfSections() -> Int {
        return self.daysDataList.count
    }
    
    func numberOfRowsInSection(section:Int) -> Int {
        let svm = daysDataList[section]
        return svm.sectionDataSource.count
    }
    
    func titleForSection(section: Int) -> NSAttributedString {
        let svm = daysDataList[section]
        return NSAttributedString.init(string: svm.sectionTitleText, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
   
    func storyAtIndexPath(indexPath: NSIndexPath) -> StoryModel{
        let svm = daysDataList[indexPath.section]
        let story = svm.sectionDataSource[indexPath.row]
        return story
    }
   
    
    //获取最新的新闻
    func getLatestStories() {
        
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/latest")
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.isLoading = false
                    self.initWithLatestStories(withDictionary: JSON as! [String : AnyObject])
                }
        }
    }
    
    func initWithLatestStories(withDictionary JSON :[String:AnyObject]) {
        self.currentLoadDayStr = JSON["date"] as! String
        let vm = SectionViewModel.init(withDictionary: JSON )
        self.daysDataList.append(vm)
        self.storiesID = vm.valueForKeyPath("sectionDataSource.storyID") as! [Int]
        let stories = JSON["top_stories"] as! [AnyObject]
        for story in stories  {
            let model = StoryModel.init(withDictionary: story as! [String : AnyObject])
            self.top_stories.append(model)
        }
        
        let first = self.top_stories.first
        let last = self.top_stories.last
        self.top_stories.append(first!)
        self.top_stories.insert(last!, atIndex: 0)
        NSNotificationCenter.defaultCenter().postNotificationName("LoadLatestDaily", object: nil)
    }
    
    //更新最新新闻
    func updateLatestStories() {
        isLoading = true
        Alamofire.request(.GET, "http://news-at.zhihu.com/api/4/news/latest")
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.isLoading = false
                    self.initWithUpdateLatestStories(withDictionary: JSON as! [String: AnyObject])
                }
        }
    }
    
    func initWithUpdateLatestStories(withDictionary JSON :[String:AnyObject]) {
        let stories = JSON["top_stories"] as! [AnyObject]
        top_stories.removeAll()
        for story in stories  {
            let model = StoryModel.init(withDictionary: story as! [String : AnyObject])
            self.top_stories.append(model)
        }
        let first = self.top_stories.first
        let last = self.top_stories.last
        self.top_stories.append(first!)
        self.top_stories.insert(last!, atIndex: 0)
        
        let newvm = SectionViewModel.init(withDictionary: JSON )
        let oldvm = daysDataList[0]
        
        if newvm.sectionTitleText == oldvm.sectionTitleText {
            let new = newvm.sectionDataSource
            let old = oldvm.sectionDataSource
            
            if new.count > old.count {
                let newItemsCount = new.count - old.count
                for i in 1...newItemsCount {
                    let model = new[newItemsCount - i]
                    storiesID.insert(model.storyID, atIndex: 0)
                }
                daysDataList.removeAtIndex(0)
                daysDataList.insert(newvm, atIndex: 0)
            }
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateLatestDaily", object: nil)

        } else {
            currentLoadDayStr = JSON["date"] as! String
            daysDataList.removeAll()
            daysDataList.append(newvm)
            NSNotificationCenter.defaultCenter().postNotificationName("UpdateLatestDaily", object: nil,userInfo:["isNewDay":true])
            
        }
    }
    
    //之前文章
    func getPreviousStories() {
        isLoading = true
        let str = "http://news-at.zhihu.com/api/4/news/before/" + currentLoadDayStr
        Alamofire.request(.GET, str)
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    self.isLoading = false
                    self.initWithPreStories(withDictionary: JSON as! [String : AnyObject])
                    
                }
        }
        
    }
    
    func initWithPreStories(withDictionary JSON :[String:AnyObject]) {
        currentLoadDayStr = JSON["date"] as! String
        let vm = SectionViewModel.init(withDictionary: JSON)
        daysDataList.append(vm)
        
        storiesID.appendContentsOf(vm.valueForKeyPath("sectionDataSource.storyID") as! [Int])
        NSNotificationCenter.defaultCenter().postNotificationName("LoadPreviousDaily", object: nil)

    }
}
