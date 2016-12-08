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

    func stringConvertToSectionTitleText(_ str:String) -> String {
        let formatter = DateFormatter.sharedInstance
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: str)
        formatter.locale = Locale.init(identifier: "zh-CH")
        formatter.dateFormat = "MM月dd日 EEEE"
        let sectionTitleText = formatter.string(from: date!)
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
    
    func numberOfRowsInSection(_ section:Int) -> Int {
        let svm = daysDataList[section]
        return svm.sectionDataSource.count
    }
    
    func titleForSection(_ section: Int) -> NSAttributedString {
        let svm = daysDataList[section]
        return NSAttributedString.init(string: svm.sectionTitleText, attributes: [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.white])
    }
   
    func storyAtIndexPath(_ indexPath: IndexPath) -> StoryModel{
        let svm = daysDataList[indexPath.section]
        let story = svm.sectionDataSource[indexPath.row]
        return story
    }
   
    
    //获取最新的新闻
    func getLatestStories() {
        Alamofire.request("http://news-at.zhihu.com/api/4/news/latest", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let JSON = response.result.value as? [String : AnyObject]{
                print("JSON: \(JSON)")
                self.isLoading = false
                self.initWithLatestStories(withDictionary: JSON )
            }
            
        }
    }
    
    func initWithLatestStories(withDictionary JSON :[String:AnyObject]) {
        self.currentLoadDayStr = JSON["date"] as! String
        let vm = SectionViewModel.init(withDictionary: JSON )
        self.daysDataList.append(vm)
        self.storiesID = vm.value(forKeyPath: "sectionDataSource.storyID") as! [Int]
        let stories = JSON["top_stories"] as! [AnyObject]
        for story in stories  {
            let model = StoryModel.init(withDictionary: story as! [String : AnyObject])
            self.top_stories.append(model)
        }
        
        let first = self.top_stories.first
        let last = self.top_stories.last
        self.top_stories.append(first!)
        self.top_stories.insert(last!, at: 0)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LoadLatestDaily"), object: nil)
    }
    
    //更新最新新闻
    func updateLatestStories() {
        isLoading = true
        Alamofire.request("http://news-at.zhihu.com/api/4/news/latest", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let JSON = response.result.value as? [String: AnyObject]{
                print("JSON: \(JSON)")
                self.isLoading = false
                self.initWithUpdateLatestStories(withDictionary: JSON)
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
        self.top_stories.insert(last!, at: 0)
        
        let newvm = SectionViewModel.init(withDictionary: JSON )
        let oldvm = daysDataList[0]
        
        if newvm.sectionTitleText == oldvm.sectionTitleText {
            let new = newvm.sectionDataSource
            let old = oldvm.sectionDataSource
            
            if (new?.count)! > (old?.count)! {
                let newItemsCount = (new?.count)! - (old?.count)!
                for i in 1...newItemsCount {
                    let model = new?[newItemsCount - i]
                    storiesID.insert((model?.storyID)!, at: 0)
                }
                daysDataList.remove(at: 0)
                daysDataList.insert(newvm, at: 0)
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateLatestDaily"), object: nil)

        } else {
            currentLoadDayStr = JSON["date"] as! String
            daysDataList.removeAll()
            daysDataList.append(newvm)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "UpdateLatestDaily"), object: nil,userInfo:["isNewDay":true])
            
        }
    }
    
    //之前文章
    func getPreviousStories() {
        isLoading = true
        let str = "http://news-at.zhihu.com/api/4/news/before/" + currentLoadDayStr
        Alamofire.request(str, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
            if let JSON = response.result.value as? [String : AnyObject]{
                print("JSON: \(JSON)")
                self.isLoading = false
                self.initWithPreStories(withDictionary: JSON )
                
            }
        }
    }
    
    func initWithPreStories(withDictionary JSON :[String:AnyObject]) {
        currentLoadDayStr = JSON["date"] as! String
        let vm = SectionViewModel.init(withDictionary: JSON)
        daysDataList.append(vm)
        
        storiesID.append(contentsOf: vm.value(forKeyPath: "sectionDataSource.storyID") as! [Int])
        NotificationCenter.default.post(name: Notification.Name(rawValue: "LoadPreviousDaily"), object: nil)

    }
}
