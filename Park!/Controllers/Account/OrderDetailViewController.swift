//
//  OrderDetailViewController.swift
//  Park!
//
//  Created by Blaer on 2018/4/2.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var lotNameLabel: UILabel!
    @IBOutlet weak var exEarnLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var beginTimeLabel: UILabel!
    @IBOutlet weak var endedTimeLabel: UILabel!
    @IBOutlet weak var chargedLabel: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    var orderId: String?
    var currentOrder : Order?
    var whenPushed :Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.title = "收据"
        if let pushed = whenPushed {
            if !pushed {
                self.closeBtn.isHidden = false
            }
        }
        
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        SVProgressHUD.dismiss()
    }

    func setup() {
        
        self.lotNameLabel.text = self.currentOrder?.lotName
        self.endedTimeLabel.text = DateFormatter.timeConvertorToMin((self.currentOrder?.toTime)!)
        self.beginTimeLabel.text = DateFormatter.timeConvertorToMin((self.currentOrder?.fromTime)!)
        self.chargedLabel.text = (self.currentOrder?.charged)! + "¥"
        self.priceLabel.text = "0.5¥/分钟"
        self.totalTimeLabel.text = DateFormatter.calculateDateGap((self.currentOrder?.fromTime)!, toTime: (self.currentOrder?.toTime)!)
        self.exEarnLabel.text = "当前订单已积累1颗星!"
        
    }
    @IBAction func callService(_ sender: Any) {
        let url = URL(string: "telprompt://+8618502093892")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
}
