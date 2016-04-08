//
//  StoryModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import Foundation

class StoryModel: NSObject {
    var title:String = ""
    var storyID: Int = 0
    var images = [String]()
    var isMultipic: Bool = false
    var type:Int = 0
    var image: String = ""
    
    override init() {
        title  = ""
        storyID = 0
        images = [String]()
        isMultipic  = false
        type = 0
        image  = ""
    }
    
    convenience init(withDictionary dic :[String:AnyObject]) {
        self.init()
        self.setValuesForKeysWithDictionary(dic)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        if key == "id" {
            self.setValue(value, forKey: "storyID")
        }
        
        if key == "multipic" {
            self.setValue(value, forKey: "isMultipic")
        }

    }
}