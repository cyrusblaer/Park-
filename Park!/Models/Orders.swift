//
//  Orders.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

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
            
            let orderRef = Database.database().reference().child("orders")
            
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
    
    class func checkUnfinishedOrder(_ phone: String, completion: @escaping (Bool, String) -> Swift.Void) {
        Database.database().reference().child("users").child(phone).child("currentOrder").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                completion(true,(snap.value as! String))
            }
            else {
                completion(false,"")
            }
        }
    }
    
    class func getTimeFromStart(_ phone: String, completion: @escaping (Int) -> Swift.Void) {
        
        Database.database().reference().child("users").child(phone).child("currentOrder").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let currentOrder = snap.value as! String
                let dateFormatter = DateFormatter()
//                dateFormatter.locale = Locale(identifier: "zh_CN")
                // 设置时间地域，不然输出的是格林尼制时间
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss 秒
                Database.database().reference().child("orders").child(currentOrder).child("fromTime").observeSingleEvent(of: .value, with: { (snap) in
                    if snap.exists() {
                        let fromTime = snap.value as! String
                        let startDate =  dateFormatter.date(from: fromTime)
                        let timeGap = Date().timeIntervalSince(startDate!)
                        completion(Int(timeGap))
                    }
                    else {
                        completion(0)
                    }
                }
            )}
            
        }
    }
    
    class func endUnfinishedOrder(_ phone: String, completion: @escaping (Bool, String) -> Swift.Void) {
        Database.database().reference().child("users").child(phone).child("currentOrder").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
               let currentOrder = snap.value as! String
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "zh_CN")
                // 设置时间地域，不然输出的是格林尼制时间
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss 秒
                let toTime = dateFormatter.string(from: Date())
                Database.database().reference().child("orders").child(currentOrder).updateChildValues(["toTime": toTime])
                Database.database().reference().child("orders").child(currentOrder).child("fromTime").observeSingleEvent(of: .value, with: { (snap) in
                    if snap.exists() {
                        let fromTime = snap.value as! String
                        let payment = self.calculatePayment(fromTime: fromTime, toTime: toTime)
                        
                        completion(true, payment)
                    }
                    else {
                        completion(false, "")
                    }
                })
            }
            else {
                completion(false, "")
            }
        }
        
    }
    
    class func calculatePayment(fromTime: String, toTime: String) -> String {
        
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "zh_CN")
        // 设置时间地域，不然输出的是格林尼制时间
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss
        
        let fromDate = dateFormatter.date(from: fromTime)
        
        let toDate = dateFormatter.date(from: toTime)
        
        let timeGap = toDate?.timeIntervalSince(fromDate!)
        // 金额计算公式在此
        let payment = String(timeGap!/60 * 0.5)
        
        return payment
    }
    
    class func didPayFee(_ user: String, order: String, charged: String, completion: @escaping (Bool) -> Swift.Void) {
        
        Database.database().reference().child("orders").child(order).updateChildValues(["charges": charged, "isFinished": true])
        
        Database.database().reference().child("users").child(user).child("currentOrder").removeValue()
        
        Database.database().reference().child("orders").child(order).child("spaceId").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let spaceId = snap.value! as! String
                Database.database().reference().child("spaces").child(spaceId).updateChildValues(["isRent": false])
                Database.database().reference().child("users").child(user).child("finishedOrder").setValue([order: charged]) { (error, ref) in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                    else {
                        completion(true)
                    }
                }
            }
            else {
                completion(false)
            }
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
