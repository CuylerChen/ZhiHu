//
//  DailyThemesViewModel.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/8.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import Foundation
import Alamofire

class DailyThemesViewModel: NSObject {
    dynamic var stories: [StoryModel]! = []
    dynamic var imageURLStr: String!
    dynamic var name: String!
    dynamic var editors: [[String: AnyObject]] = []
    
    
    override init() {
        super.init()
        stories = []
        imageURLStr = ""
        name = ""
        editors = []
    }
    
    func getDailyThemesDataWithThemeID(themeID: Int) {
        let str = "http://news-at.zhihu.com/api/4/theme/\(themeID)"
        Alamofire.request(.GET, str )
            .responseJSON { response in
                if let JSON = response.result.value {
                    let stories = JSON["stories"] as! [AnyObject]
                    for story in stories  {
                        let model = StoryModel.init(withDictionary: story as! [String : AnyObject])
                        self.stories.append(model)
                    }
                    self.imageURLStr = JSON["background"] as! String
                    self.name = JSON["name"] as! String
                    self.editors = JSON["editors"] as! [[String:AnyObject]]
                }
        }
    }
    
}
