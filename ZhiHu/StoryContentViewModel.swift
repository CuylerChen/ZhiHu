//
//  StoryContentViewModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit
import Alamofire

class StoryContentViewModel: NSObject {
    dynamic var storyModel: StoryContentModel!
    var loadedStoryID: Int = 0
    var storiesID: [Int]! = []
    var type : Int = 0
    
    override init() {
        storyModel = StoryContentModel.init()
        loadedStoryID = 0
        storiesID = []
        type  = 0
    }
    
    convenience init(withCurID : Int,storiesID: [Int]) {
        self.init()
        loadedStoryID = withCurID
        self.storiesID = storiesID
    }
    
    func ImageURLString() -> String {
        return storyModel.image
    }
    
    func titleAttText() -> NSAttributedString {
         return NSAttributedString.init(string: storyModel.title, attributes: [NSFontAttributeName:UIFont.boldSystemFontOfSize(18),NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func imaSourceText() -> String {
        let imaSourceText = "图片：" + storyModel.image_source
        return imaSourceText
    }
    
    func htmlStr() ->String {
        let htmlStr = "<html><head><link rel=\"stylesheet\" href=\(storyModel.css[0])></head><body>\(storyModel.body)</body></html>"
       return htmlStr
    }
    
    func share_URL() -> String {
        return storyModel.share_url
    }
    
    func storyType() -> Int {
        type = storyModel.type
        return storyModel.type
    }
    
    func recommenders() -> [[String:String]] {
        return storyModel.recommenders
    }
    
    func getStoryContentWithStoryID(storyID:Int) {
        let str = "http://news-at.zhihu.com/api/4/news/\(storyID)"
        Alamofire.request(.GET, str )
            .responseJSON { response in
                if let JSON = response.result.value {
                    self.storyModel = StoryContentModel.init(withDictionary: JSON as! [String:AnyObject])
                    print("JSON: \(JSON)")
                    self.loadedStoryID = storyID
                    //NSNotificationCenter.defaultCenter().postNotificationName("loadNewPages", object: nil)
                }
        }
        
    }
    
    func getPreviousStoryContent() {
        let index = storiesID.indexOf(loadedStoryID)
        if index >= 1 {
            let preStoryID = storiesID[index! - 1]
            getStoryContentWithStoryID(preStoryID)
        }
    }
    
    func getNextStoryContent() {
        let index = storiesID.indexOf(loadedStoryID)
        if index < storiesID.count - 1 {
            let nextStoryID = storiesID[index! + 1]
            getStoryContentWithStoryID(nextStoryID)
        }
    }
    
    
}
