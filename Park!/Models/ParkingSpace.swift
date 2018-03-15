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
    
    class func addParkingSpaceWith(ownerId: String, lotId: String, createTime: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let parkingSpaceRef = WDGSync.sync().reference().child("parkingspaces")
        
        let spaceId = "1"
        
        let spaceInfo = [spaceId :["ownerId": ownerId, createTime: createTime]] as [String : Any]
        
        parkingSpaceRef.setValue(spaceInfo)
        
    }
    
    
    
    init(ownerId: String?, lotId: String?, createTime: String?, isRent: Bool, tenantId: String?) {
        self.ownerId = ownerId
        self.lotId = ownerId
        self.createTime = createTime
        self.isRent = isRent
        self.tenantId = tenantId
    }
    
}
