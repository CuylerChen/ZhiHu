//
//  StoryContentModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/7.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import Foundation

class StoryContentModel: NSObject {
    var body: String! = ""
    var image_source: String! = ""
    var title: String! = ""
    var image: String! = ""
    var storyID: Int = 0
    var css: [String]! = []
    var share_url: String! = ""
    var recommenders: [[String:String]]! = []
    var type: Int = 0
    
    override init() {
        body = ""
        image_source = ""
        title  = ""
        image = ""
        storyID = 0
        css = [String]()
        share_url = ""
        recommenders = []
        type = 0
    }
    
    convenience init(withDictionary dic :[String:AnyObject]) {
        self.init()
        self.setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if key == "image_source" {
            self.setValue(value, forUndefinedKey: "image_source")
        }
        
        if key == "id" {
            self.setValue(value, forKey: "storyID")
        }
        
    }
}