//
//  ParkingSpace.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ParkingSpace {
    
    //MARK: Properties
    var spaceId: String?
    var ownerId: String?
    var lotId: String?
    var createTime: String?
    var isRent: Bool
    var tenantId: String?
    
    class func addParkingSpaceWith(ownerId: String, lotId: String, isReady: Bool, completion: @escaping (Bool) -> Swift.Void) {
        
        let parkingSpaceRef = Database.database().reference().child("spaces")
        
        var spaceId : String?
        parkingSpaceRef.queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
            let values = snap.value as? NSDictionary
            if values?.count == 0 {
                print("Database Failure")
            }
            else {
                spaceId = String(format: "%6d", (values?.count)!+1)
                spaceId = spaceId?.replacingOccurrences(of: " ", with: "0")
            }
            let spaceInfo = ["owner": ownerId, "lotId": lotId, "isRent": false, "isReady": isReady] as [String : Any]
            
            parkingSpaceRef.child(spaceId!).setValue(spaceInfo) { (error, ref) in
                if let error = error{
                    print(error.localizedDescription)
                    completion(false)
                }
                else {
                    completion(true)
                    let currentUserSpaceRef = Database.database().reference().child("users").child(ownerId).child("spaces").child(spaceId!)
                    currentUserSpaceRef.setValue([spaceId! : spaceId!])
                }
            }
        
        })
        
    }
    
    class func changeSpaceStatus(spaceId: String, isReady: Bool, completion: @escaping (Bool) -> Swift.Void) {
        
        let currentSpaceRef = Database.database().reference().child("spaces").child(spaceId)
        
        currentSpaceRef.updateChildValues(["isReady" : isReady]) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            else {
                completion(true)
            }
        }
        
    }
    
    class func deleteSpace(ownerId: String, spaceId: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let parkingSpaceRef = Database.database().reference().child("spaces").child(spaceId)
        parkingSpaceRef.removeValue()
        
        let currentUserSpaceRef = Database.database().reference().child("users").child(ownerId).child("spaces").child(spaceId)
        
        currentUserSpaceRef.removeValue()
        
        completion(true)
        
    }
    
    // 设定返回值，0位为isRent，1为notRent，2车位不存在
    class func checkSpaceStatus(_ spaceId: String, completion: @escaping (Int) -> Swift.Void) {
        
        Database.database().reference().child("spaces").child(spaceId).observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let dict = snap.value as? NSDictionary
                let isRent = dict!["isRent"] as! Bool
                let isReady = dict!["isReady"] as! Bool
                
                if isReady {
                    if isRent {
                        completion(0)
                    }
                    else {
                        completion(1)
                    }
                }
                else {
                    completion(2)
                }
                
            }
            else {
                completion(3)
            }
        }
        
    }
    
    init(ownerId: String?, lotId: String?, createTime: String?, isRent: Bool, tenantId: String?) {
        self.ownerId = ownerId
        self.lotId = ownerId
        self.createTime = createTime
        self.isRent = isRent
        self.tenantId = tenantId
    }
    
}
