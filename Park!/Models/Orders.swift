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

class Order {
    
    var orderId: String?
    var isFinished: Bool
    var fromTime: String?
    var toTime: String?
    var spaceId: String?
    var user: String?
    var owner: String?
    var supervisorId: String?
    var charged: String?
    var lotName: String?
    
    class func createOrderWith(spaceId: String, user: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN")
        // 设置时间地域，不然输出的是格林尼制时间
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss 秒
        let timeString = dateFormatter.string(from: Date())
        
        let orderId = timeString + spaceId
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
//            let owner = userInformation["phone"] as! String
            
            let orderRef = Database.database().reference().child("orders")
            
            
            Database.database().reference().child("spaces").child(spaceId).observeSingleEvent(of: .value) { (snapshot) in
                if let data = snapshot.value as? [String: Any]
                {
                    let lotId = data["lotId"] as! String
                    let owner = data["owner"] as! String
                    Database.database().reference().child("parkinglot").child(lotId).observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.exists()
                        {
                            let data = snapshot.value as! [String: Any]
                            let lotName = data["name"] as! String
                            let supervisorId = data["supervisorId"]! as! String
                            
                            
                            let orderInfo = ["isFinished" : false, "user": user, "spaceId" : spaceId, "fromTime": timeString, "supervisorId": supervisorId, "lot": lotName, "owner": owner] as [String : Any]
                            orderRef.child(orderId).setValue(orderInfo, withCompletionBlock: { (error, ref) in
                                if let error = error {
                                    print(error.localizedDescription)
                                    completion(false)
                                }
                                else {
                                    completion(true)
                                    Database.database().reference().child("users").child(user).updateChildValues(["currentOrder" : orderId])
                                    Database.database().reference().child("spaces").child(spaceId).updateChildValues(["isRent": true])
                                }
                            })
                        }
                    })
                }
            }
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
    
    class func getUnfinishedOrderStartTime(_ phone: String, completion: @escaping (String)-> Swift.Void) {
        Database.database().reference().child("users").child(phone).child("currentOrder").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let currentOrder = snap.value as! String
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "zh_CN")
                // 设置时间地域，不然输出的是格林尼制时间
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                // 定义输出的内容格式  yyyy 年， MM 月， dd 日， HH 24小时，mm 分， ss 秒
                let toTime = dateFormatter.string(from: Date())
                
                Database.database().reference().child("orders").child(currentOrder).child("fromTime").observeSingleEvent(of: .value, with: { (snap) in
                    if snap.exists() {
                        let fromTime = snap.value as! String
                        let payment = self.calculatePayment(fromTime: fromTime, toTime: toTime)
                        
                        completion(payment)
                    }
                    else {
                        completion("")
                    }
                })
            }
            else {
                completion("")
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
        let payment = String(timeGap!/60 * 0.1)
        
        return payment
    }
    
    class func didPayFee(_ user: String, order: String, charged: String, completion: @escaping (Bool) -> Swift.Void) {
        
        Database.database().reference().child("orders").child(order).updateChildValues(["charged": charged, "isFinished": true])
        
        Database.database().reference().child("users").child(user).child("currentOrder").removeValue()
        
        Database.database().reference().child("orders").child(order).child("spaceId").observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let spaceId = snap.value! as! String
                Database.database().reference().child("spaces").child(spaceId).updateChildValues(["isRent": false])
                
                Database.database().reference().child("users").child(user).child("finishedOrder").child(order).setValue(charged) { (error, ref) in
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
    
    class func info(_ orderId: String, completion: @escaping (Order) -> Swift.Void) {
        Database.database().reference().child("orders").child(orderId).observeSingleEvent(of: .value) { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let isFinished = data["isFinished"] as! Bool
                let fromTime = data["fromTime"] as! String
                let toTime = data["toTime"] as! String
                let spaceId = data["spaceId"] as! String
                let user = data["user"] as! String
                let owner = data["owner"] as! String
                let supervisorId = data["supervisorId"] as! String
                let lotName = data["lot"] as! String
                
                let order = Order.init(orderId: orderId, isFinished: isFinished, fromTime: fromTime, toTime: toTime, spaceId: spaceId, user: user, owner: owner, supervisorId: supervisorId, lotName: lotName)
                
                if isFinished {
                    let charged = data["charged"] as! String
                    order.charged = charged
                }
                completion(order)
            }
        }
    }
    
    class func getAllFinishedOrder(_ userId: String, completion: @escaping ([Order]) -> Swift.Void) {
        
       var finishedOrders : [Order] = []
        Database.database().reference().child("users").child(userId).child("finishedOrder").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let data = snapshot.value as? [String: String]
                
                var count = 0
                for item in data! {
                    
                    Order.info(item.key, completion: { (order) in
                        
                        finishedOrders.append(order)
                        count = count + 1
                        if count == data?.count {
                            completion(finishedOrders)
                        }
                    })
                }
            }
    
        }
        
    }
    
    init(orderId: String?, isFinished: Bool, fromTime: String?, toTime: String?, spaceId: String?, user: String?, owner : String?, supervisorId: String?, lotName: String?) {
        self.orderId = orderId
        self.isFinished = isFinished
        self.fromTime = fromTime
        self.toTime = toTime
        self.spaceId = spaceId
        self.user =  user
        self.owner = owner
        self.supervisorId = supervisorId
        self.charged = ""
        self.lotName = lotName
    }
    
}
