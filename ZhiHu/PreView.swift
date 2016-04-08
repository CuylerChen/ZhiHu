//
//  PreView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/7.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class PreView: UIView {
    var     circleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        circleLayer = CAShapeLayer.init()
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.grayColor().CGColor
        circleLayer.lineWidth = 10
        circleLayer.path = UIBezierPath.init(arcCenter: self.center, radius: 80, startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: true).CGPath
        circleLayer.lineCap = kCALineCapRound
        self.layer.addSublayer(circleLayer)
        loadingAnimation()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadingAnimation() {
        let strokeStartAnimation = CABasicAnimation.init(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1
        
        let strokeEndAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let group = CAAnimationGroup.init()
        group.animations = [strokeStartAnimation,strokeEndAnimation]
        group.repeatCount = 10
        group.duration = 2.4
        circleLayer.addAnimation(group, forKey: nil)
        
    }
}
