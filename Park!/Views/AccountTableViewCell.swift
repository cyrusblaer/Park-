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
    
    var type: String = "" {
        didSet {
            switch type {
            case "个人信息":
                titleTextLabel.text = "个人信息"
                imageIcon.image = UIImage.init(named: "profile")
            case "消费记录":
                titleTextLabel.text = "消费记录"
                imageIcon.image = UIImage.init(named: "orders")
            case "会员":
                titleTextLabel.text = "会员"
                imageIcon.image = UIImage.init(named: "club")
            case "设置":
                titleTextLabel.text = "设置"
                imageIcon.image = UIImage.init(named: "setting")
            case "关于软件":
                titleTextLabel.text = "关于软件"
                imageIcon.image = UIImage.init(named: "about")
            case "车位管理":
                titleTextLabel.text = "车位管理"
                imageIcon.image = UIImage.init(named: "about")
            default:
                titleTextLabel.text = ""
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in self.contentView.superview!.subviews {
            let subview = item
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
