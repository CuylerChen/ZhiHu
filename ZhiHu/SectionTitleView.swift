//
//  SectionTitleView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class SectionTitleView: UITableViewHeaderFooterView {
   
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.setCenterX(self.width() / 2)
    }
}
