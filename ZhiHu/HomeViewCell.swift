//
//  HomeViewCell.swift
//  ZhiHu
//
//  Created by 吴明亮 on 16/4/6.
//  Copyright © 2016年 吴明亮. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var imaView: UIImageView!
    @IBOutlet weak var warnImageView: UIImageView!
    @IBOutlet weak var imaViewWidthConstraint: NSLayoutConstraint!
    
    var  storyModel: StoryModel!
    
    func updateUIWithStoryModel(model: StoryModel) {
        storyModel = model
        titleLab.text = model.title;
        if model.images.isEmpty {
            imaViewWidthConstraint.constant = 0
        } else {
            let imageUrl = model.images.first!
            imaView.af_setImageWithURL(NSURL.init(string: imageUrl)!)
        }
        
        if storyModel.isMultipic {
            if  (warnImageView.image != nil)  {
                warnImageView.image = UIImage.init(named: "Home_Morepic")
            }
            warnImageView.hidden = false
        } else {
            warnImageView.hidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /*required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
}
