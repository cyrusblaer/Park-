//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import FoldingCell
import UIKit

protocol NaviButtonPressDelegate {
    func naviButtonPress(destinationTitle: String)
}

class HomeTableViewCell: FoldingCell {

    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var foreNameLabel: UILabel!
    @IBOutlet var titleNameLabel: UILabel!
    @IBOutlet var profileNameLabel: UILabel!
    
    @IBOutlet weak var smallEstimatedTime: UILabel!
    @IBOutlet weak var foreAddressLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var usedSpaceLabel: UILabel!
    @IBOutlet weak var estimatedTime: UILabel!
    
    @IBOutlet weak var numberOfSpaceLabel: UILabel!
    @IBOutlet weak var rentNumberLabel: UILabel!
    @IBOutlet weak var isRegisteredLabel: UILabel!
    
    @IBOutlet weak var navButton: UIButton!
    
    var delegate: NaviButtonPressDelegate?
    
    var name: String = "" {
        didSet {
            foreNameLabel.text = name
            titleNameLabel.text = name
            profileNameLabel.text = name
        }
    }
    
    var address: String = "" {
        didSet {
            foreAddressLabel.text = address
            addressLabel.text = address
        }
    }
    
    var isRegistered: Bool = false {
        didSet {
            if isRegistered {
                isRegisteredLabel.text = "是"
            }
            else {
                isRegisteredLabel.text = "否"
            }
        }
    }
    
    var city: String = "" {
        didSet {
            self.cityLabel.text = city
        }
    }
    
    var district: String = "" {
        didSet {
            self.districtLabel.text = district
        }
    }

    var rentNumber: Int = 0 {
        didSet {
            self.rentNumberLabel.text = String(rentNumber)
        }
    }
    
    var numberOfSpace: Int = 0 {
        didSet {
            self.numberOfSpaceLabel.text = String(numberOfSpace)
            self.usedSpaceLabel.text = "\(numberOfSpace - rentNumber)/\(numberOfSpace)"
        }
    }
    
    var distance : String = "" {
        
        didSet {
            self.distanceLabel.text = distance
        }
        
    }
    
    var time: String = "" {
        didSet {
            self.estimatedTime.text = time
            self.smallEstimatedTime.text = time
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension HomeTableViewCell {

    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
        if delegate != nil {
            delegate?.naviButtonPress(destinationTitle: self.name)
        }
    }
}
