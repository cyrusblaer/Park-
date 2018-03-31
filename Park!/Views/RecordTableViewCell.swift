//
//  RecordTableViewCell.swift
//  Park!
//
//  Created by Blaer on 30/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework

class RecordTableViewCell: UITableViewCell {
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = FlatWhite()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
