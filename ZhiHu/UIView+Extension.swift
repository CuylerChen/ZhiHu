//
//  UIView+Extension.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

extension UIView {
    
    func left() ->CGFloat {
        return self.frame.origin.x
    }
    
    func setLeft(left: CGFloat) {
        self.frame.origin.x = left
    }
    
    func right() ->CGFloat {
        return self.frame.origin.x + self.frame.size.width
    }
    
    func setRight(right: CGFloat) {
        self.frame.origin.x = right - self.frame.size.width
    }
   
    func top() ->CGFloat {
        return self.frame.origin.y
    }
    
    func setTop(top: CGFloat) {
        self.frame.origin.y = top
    }
    
    
    func bottom() ->CGFloat {
        return self.frame.origin.y + self.frame.size.height
    }
    
    func setBottom(bottom: CGFloat) {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    func width() ->CGFloat {
        return self.frame.size.width
    }
    
    func setWidth(width: CGFloat) {
        self.frame.size.width = width
    }
    
    func height() ->CGFloat {
        return self.frame.size.height
    }
    
    func setHeight(height: CGFloat) {
        self.frame.size.height = height
    }
    
    func centerX() -> CGFloat{
        return self.center.x
    }
    
    func setCenterX(centerX:CGFloat) {
         self.center = CGPointMake(centerX, self.center.y);
    }
    
    func centerY() -> CGFloat{
        return self.center.y
    }
    
    func setCenterY(centerY:CGFloat) {
        self.center = CGPointMake(self.center.x, centerY);
    }
    
}