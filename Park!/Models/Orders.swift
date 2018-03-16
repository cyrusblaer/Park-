//
//  Orders.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import Wilddog

class Orders {
    
    var orderId: String?
    var isFinished: Bool
    var fromTime: String?
    var toTime: String?
    var spaceId: String?
    var tenantId: String?
    var owner: String?
    var supervisorId: String?
    
    class func createOrderWith(spaceId: String, tenantId: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        // 设置时间地域，不然输出的是格林尼制时间
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyyMMddHHmm")
        // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss 秒
        let timeString = dateFormatter.string(from: Date())
        
        let orderId = timeString + spaceId
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let owner = userInformation["phone"] as! String
            
            let orderRef = WDGSync.sync().reference().child("orders")
            
            let orderInfo = ["orderId" : orderId, "isFinished" : false, "tenantId": tenantId, "spaceId" : spaceId, "fromTime": timeString, "owner": owner] as [String : Any]
            orderRef.setValue(orderInfo, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                }
                else {
                    completion(true)
                }
            })
        }
    }
    
    init(orderId: String?, isFinished: Bool, fromTime: String?, toTime: String?, spaceId: String?, tenantId: String?, owner : String?, supervisorId: String?) {
        self.orderId = orderId
        self.isFinished = isFinished
        self.fromTime = fromTime
        self.toTime = toTime
        self.spaceId = spaceId
        self.tenantId =  tenantId
        self.owner = owner
        self.supervisorId = supervisorId
    }
    
}
