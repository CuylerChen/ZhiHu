//
//  RefreshView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    private var  indicatorView: UIActivityIndicatorView!
    private var  whiteCircleLayer: CAShapeLayer!
    private var  grayCircleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        indicatorView = UIActivityIndicatorView.init(frame: CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)))
        self.addSubview(indicatorView)
        
        let   radius = min(frame.size.width, frame.size.height) / 2 - 3
        grayCircleLayer = CAShapeLayer.init()
        grayCircleLayer.lineWidth = 0.5
        grayCircleLayer.strokeColor = UIColor.grayColor().CGColor
        grayCircleLayer.fillColor = UIColor.clearColor().CGColor
        grayCircleLayer.opacity = 0
        grayCircleLayer.path = UIBezierPath.init(ovalInRect: CGRectMake(self.width() / 2 - radius, self.height() / 2 - radius, 2 * radius, 2 * radius)).CGPath
        self.layer.addSublayer(grayCircleLayer)
        
        whiteCircleLayer = CAShapeLayer.init()
        whiteCircleLayer.lineWidth = 0.5
        whiteCircleLayer.strokeColor = UIColor.grayColor().CGColor
        whiteCircleLayer.fillColor = UIColor.clearColor().CGColor
        whiteCircleLayer.opacity = 0
        whiteCircleLayer.path = UIBezierPath.init(arcCenter: CGPointMake(self.width() / 2, self.height() / 2), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI * 2.5) , clockwise: true).CGPath
        self.layer.addSublayer(whiteCircleLayer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redrawFromProgress(progress:CGFloat) {
        if progress > 0 {
            whiteCircleLayer.opacity = 1
            grayCircleLayer.opacity = 1
        } else {
            whiteCircleLayer.opacity = 0
            grayCircleLayer.opacity = 0
        }
        whiteCircleLayer.strokeEnd = progress
    }
    
    func startAnimation() {
        indicatorView.startAnimating()
    }
    
    func stopAnimation() {
        indicatorView.stopAnimating()
    }

}
