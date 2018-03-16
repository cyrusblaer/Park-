//
//  HomePageTableViewCell.swift
//  Park!
//
//  Created by Blaer on 16/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet weak var spaceIdTextField: UITextField!
    
    @IBAction func startParkingAction(_ sender: Any) {
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
