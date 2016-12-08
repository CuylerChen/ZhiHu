//
//  TopStoryView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class TopStoryView: UIView {
    var  imageView: UIImageView!
    var  label:     UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(imageView)
        
        label = UILabel.init()
        label.numberOfLines = 0
        self.addSubview(label)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
