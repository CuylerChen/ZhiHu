//
//  NSDateFormatter+Extension.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/7.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import Foundation

extension NSDateFormatter {
        class var sharedInstance : NSDateFormatter {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var staticInstance : NSDateFormatter? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.staticInstance = NSDateFormatter()
        }
        
        return Static.staticInstance!
    }
}