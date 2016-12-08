//
//  ThemeItemModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import Foundation

class ThemeItemModel: NSObject {
    var name: String!
    var themeID: Int = 0
    
    override init() {
        name  = ""
        themeID = 0
    }
    
    convenience init(withDictionary dic :[String:AnyObject]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        if key == "id" {
            self.setValue(value, forKey: "themeID")
        }
    }
}
