//
//  SpaceTableViewCell.swift
//  Park!
//
//  Created by Blaer on 2018/5/8.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class SpaceTableViewCell: UITableViewCell {

    @IBOutlet weak var spaceID: UILabel!
    
    @IBOutlet weak var lotName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
