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
            case 1:
                titleTextLabel.text = "消费记录"
            case 2:
                titleTextLabel.text = "设置"
            case 3:
                titleTextLabel.text = "安全"
            default:
                titleTextLabel.text = ""
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
