//
//  SearchLotTableViewCell.swift
//  Park!
//
//  Created by Blaer on 20/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class SearchLotTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextLabel: UILabel!
    
    var title: String! {
        didSet {
            titleTextLabel.text = title
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
