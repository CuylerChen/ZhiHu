//
//  RefreshView.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class RefreshView: UIView {
    fileprivate var  indicatorView: UIActivityIndicatorView!
    fileprivate var  whiteCircleLayer: CAShapeLayer!
    fileprivate var  grayCircleLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        indicatorView = UIActivityIndicatorView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.addSubview(indicatorView)
        
        let   radius = min(frame.size.width, frame.size.height) / 2 - 3
        grayCircleLayer = CAShapeLayer.init()
        grayCircleLayer.lineWidth = 0.5
        grayCircleLayer.strokeColor = UIColor.gray.cgColor
        grayCircleLayer.fillColor = UIColor.clear.cgColor
        grayCircleLayer.opacity = 0
        grayCircleLayer.path = UIBezierPath.init(ovalIn: CGRect(x: self.width() / 2 - radius, y: self.height() / 2 - radius, width: 2 * radius, height: 2 * radius)).cgPath
        self.layer.addSublayer(grayCircleLayer)
        
        whiteCircleLayer = CAShapeLayer.init()
        whiteCircleLayer.lineWidth = 0.5
        whiteCircleLayer.strokeColor = UIColor.gray.cgColor
        whiteCircleLayer.fillColor = UIColor.clear.cgColor
        whiteCircleLayer.opacity = 0
        whiteCircleLayer.path = UIBezierPath.init(arcCenter: CGPoint(x: self.width() / 2, y: self.height() / 2), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI * 2.5) , clockwise: true).cgPath
        self.layer.addSublayer(whiteCircleLayer)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func redrawFromProgress(_ progress:CGFloat) {
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
