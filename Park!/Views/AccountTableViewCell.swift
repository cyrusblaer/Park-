//
//  AccountTableViewCell.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    @IBOutlet var titleTextLabel: UILabel!
    
    @IBOutlet var imageIcon: UIImageView!
    
    var type: Int = 0 {
        didSet {
            switch type {
            case 0:
                titleTextLabel.text = "个人信息"
                imageIcon.image = UIImage.init(named: "profile")
            case 1:
                titleTextLabel.text = "消费记录"
                imageIcon.image = UIImage.init(named: "orders")
            case 2:
                titleTextLabel.text = "会员"
                imageIcon.image = UIImage.init(named: "club")
            case 3:
                titleTextLabel.text = "设置"
                imageIcon.image = UIImage.init(named: "setting")
            default:
                titleTextLabel.text = "关于软件"
                imageIcon.image = UIImage.init(named: "about")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in self.contentView.superview!.subviews {
            var subview = item as! UIView
            if NSStringFromClass(subview.classForCoder).hasSuffix("SeparatorView") {
                subview.isHidden = false
                var frame = subview.frame
                frame.origin.x += self.separatorInset.left
                frame.size.width -= self.separatorInset.right
                subview.frame  = frame
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
