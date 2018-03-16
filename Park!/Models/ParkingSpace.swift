//
//  ParkingSpace.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import Wilddog
import UIKit

class ParkingSpace {
    
    //MARK: Properties
    var spaceId: String?
    var ownerId: String?
    var lotId: String?
    var createTime: String?
    var isRent: Bool
    var tenantId: String?
    
    class func addParkingSpaceWith(ownerId: String, lotId: String, isReady: Bool, completion: @escaping (Bool) -> Swift.Void) {
        
        let parkingSpaceRef = WDGSync.sync().reference().child("spaces")
        
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
                    let currentUserSpaceRef = WDGSync.sync().reference().child("users").child(ownerId).child("spaces").child(spaceId!)
                    currentUserSpaceRef.setValue([spaceId! : spaceId!])
                }
            }
        
        })
        
    }
    
    class func changeSpaceStatus(spaceId: String, isReady: Bool, completion: @escaping (Bool) -> Swift.Void) {
        
        let currentSpaceRef = WDGSync.sync().reference().child("spaces").child(spaceId)
        
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
        
        let parkingSpaceRef = WDGSync.sync().reference().child("spaces").child(spaceId)
        parkingSpaceRef.removeValue()
        
        let currentUserSpaceRef = WDGSync.sync().reference().child("users").child(ownerId).child("spaces").child(spaceId)
        
        currentUserSpaceRef.removeValue()
        
        completion(true)
        
    }
    
    init(ownerId: String?, lotId: String?, createTime: String?, isRent: Bool, tenantId: String?) {
        self.ownerId = ownerId
        self.lotId = ownerId
        self.createTime = createTime
        self.isRent = isRent
        self.tenantId = tenantId
    }
    
}
