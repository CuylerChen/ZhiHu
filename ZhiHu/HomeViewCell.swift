//
//  HomeViewCell.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    var titleLab: UILabel!
    var imaView: UIImageView!
    var warnImageView: UIImageView!
    
    var  storyModel: StoryModel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLab = UILabel.init(frame: CGRect.init(x: 10, y: 10 , width: self.bounds.size.width - 110, height: 80 ))
        imaView = UIImageView.init(frame: CGRect.init(x: self.bounds.size.width - 100, y: 10, width: 80, height: 80))
        warnImageView = UIImageView.init(frame: CGRect.init(x: self.bounds.size.width - 50, y: 70, width: 40, height: 20))
        
        self.contentView.addSubview(titleLab)
        self.contentView.addSubview(imaView)
        self.contentView.addSubview(warnImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUIWithStoryModel(_ model: StoryModel) {
        storyModel = model
        titleLab.text = model.title;
        if !model.images.isEmpty {
            let imageUrl = model.images.first!
            imaView?.af_setImage(withURL: URL.init(string: imageUrl)!)
        }

        if storyModel.isMultipic {
            if  (warnImageView.image != nil)  {
                warnImageView.image = UIImage.init(named: "Home_Morepic")
            }
            warnImageView.isHidden = false
        } else {
            warnImageView.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
