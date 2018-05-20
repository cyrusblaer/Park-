//
//  RecordCollectionViewCell.swift
//  Park!
//
//  Created by Blaer on 2018/5/20.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class RecordCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var chargedLabel: UILabel!
    
    
    var order : Order! {
        didSet {
            self.nameLabel.text = order.lotName
            if order.toTime != nil {
                self.timeLabel.text = self.timeConvertor(order.toTime!)
                self.chargedLabel.text = order.charged?.appending("¥")
            }
            else {
                self.timeLabel.text = self.timeConvertor(order.fromTime!)
                self.chargedLabel.text = "未结束"
            }
        }
    }
    
    private func timeConvertor(_ date: String) -> String? {
        let dateFormattor1 = DateFormatter()
        dateFormattor1.dateFormat = "yyyyMMddHHmm"
        
        let dateFormattor2 = DateFormatter()
        dateFormattor2.dateFormat = "yyyy年MM月dd日HH时"
        
        let formattedDate = dateFormattor2.string(from: dateFormattor1.date(from: date)!)
        
        return formattedDate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    
}
