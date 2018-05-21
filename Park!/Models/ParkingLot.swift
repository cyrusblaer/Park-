//
//  ParkingLot.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ParkingLot {
    
    let uid: String
    let numberOfSpace: Int
    let rentNumber: Int
    let supervisorId: String
    let location: CLLocationCoordinate2D
    let name: String
    let address : String
    let isRegistered: Bool
    var distanceFromLocation = CLLocationDistance.init()
    var city = String.init()
    var district = String.init()
    var image = UIImage.init()
//    let enterLocation: CLLocationCoordinate2D
    
    class func registerParkingLot(withUid: String, name: String, address: String, location: CLLocationCoordinate2D,  numberOfSpace: Int, rentNumber: Int, supervisorId: String,  completion: @escaping (Bool) -> Swift.Void) {
        
        let values = [
            "name": name,
            "address": address,
            "location": [
                "latitude": location.latitude,
                "longitude": location.longitude
            ],
            "numberOfSpace": numberOfSpace,
            "rentNumber": rentNumber,
            "supervisorId": supervisorId,
            "isRegistered": true
            ] as [String : Any]
        
        
        Database.database().reference().child("parkinglot").child(withUid).setValue(values) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            else {
                completion(true)
            }
        }
        
    }
    
    class func searchLotInDatabase(_ uid: String, completion: @escaping (Bool, ParkingLot?) -> Swift.Void) {
        
        Database.database().reference().child("parkinglot").child(uid).observeSingleEvent(of: .value) { (snap) in
            if snap.exists() {
                let values = snap.value as? NSDictionary
                let location = values!["location"] as? NSDictionary
                let name = values!["name"] as! String
                let address = values!["address"] as! String
                let rentNumber = values!["rentNumber"] as! Int
                let numberOfSpace = values!["numberOfSpace"] as! Int
                let supervisorId = values!["supervisorId"] as! String
                
                let clLocation = CLLocationCoordinate2DMake(location!["latitude"] as! Double, location!["longitude"] as! Double)
                
                let lot = ParkingLot.init(uid, name: name, address: address, location: clLocation, numberOfSpace: numberOfSpace, rentNumber: rentNumber, supervisorId: supervisorId, isRegistered: true)
                completion(true, lot)
            }
            else {
                completion(false, nil)
            }
        }
        
    }
    
    init(_ uid: String, name: String, address: String, location: CLLocationCoordinate2D,  numberOfSpace: Int, rentNumber: Int, supervisorId: String, isRegistered: Bool ) {
        self.uid = uid
        self.name = name
        self.location = location
        self.rentNumber = rentNumber
//        self.enterLocation = enterLocation
        self.supervisorId = supervisorId
        self.address = address
        self.numberOfSpace = numberOfSpace
        self.isRegistered = isRegistered
        
        self.city = ""
        self.district = ""
    }
    
}
