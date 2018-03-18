//
//  Users.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let password: String
    let phone: String
    let userID: String
    var profilePic: UIImage
    
    //MARK: Methods
    
    class func registerUser(withName: String, phone: String, password: String,  profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        let storageRef = Storage.storage().reference().child("usersProfilePics").child(phone)
        let imageData = UIImageJPEGRepresentation(profilePic, 0.1)
        storageRef.putData(imageData!, metadata: nil, completion: { (metadata, err) in
            if err == nil {
                let path = metadata?.downloadURL()?.absoluteString
                let values = ["name": withName, "password": password, "profilePicLink": path!, "userType": 0] as [String : Any]
                
                Database.database().reference().child("users").child(phone).setValue(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["phone" : phone, "password" : password, "name": withName]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        completion(true)
                    }
                    else {
                        completion(false)
                    }
                })
            }
            else {
                completion(false)
            }
        })
    
    }
    
   /**
    //  register new user with phone number
    class func registerUser(withName: String, phone: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        
        WDGAuth.auth()?.createUser(withPhone: phone, password: password, completion: { (user, error) in
            if error == nil {
//                user?.sendPhoneVerification(completion: nil)
                
                if let user = user {
                    let changeRequest = user.profileChangeRequest()
                    changeRequest.displayName = withName
//                    changeRequest.photoURL =
//                        NSURL(string: "https://example.com/jane-q-user/profile.jpg") as URL?
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // 发生错误
                            print(error.localizedDescription)
                        } else {
                            // 更新成功
                            print("更新成功")
                            
                            createUserInDatabaseWith(uid: user.uid, phone: user.phone!, userType: 0, completion: { (state) in
                                if state {
                                    print("database insert successed")
                                }
                                else {
                                    print("Database insert error")
                                }
                            })
                        }
                    }
                }
                
                let userInfo = ["phone" : phone, "password" : password, "displayName": withName, "userType": nil]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            }
        })
        
    }
 
    class func createUserInDatabaseWith(uid: String, phone: String, userType: Int, completion: @escaping (Bool) -> Swift.Void) {
        let usersRef = WDGSync.sync().reference().child("users")
        
//        if usersRef.accessibilityElementCount() == 0 {
//            WDGSync.sync().reference().setValue(["users" : nil])
//        }
        
        let userInfo = ["uid": uid, "userType": userType] as [String : Any]
        
        usersRef.child(phone).setValue(userInfo) { (error, ref) in
            if error == nil {
                completion(true)
                UserDefaults.standard.set(userType, forKey: "userType")
            }
            else {
                 completion(false)
            }
        }
    }
    */
    class func updateUserInfoWith(userType: Int, name: String,  completion: @escaping (Bool) -> Swift.Void) {
//        let currentUser = WDGAuth.auth()?.currentUser
//        if let user = currentUser {
//            let changeRequest = user.profileChangeRequest()
//            changeRequest.displayName = name
//            //                    changeRequest.photoURL =
//            //                        NSURL(string: "https://example.com/jane-q-user/profile.jpg") as URL?
//            changeRequest.commitChanges { error in
//                if let error = error {
//                    // 发生错误
//                    print(error.localizedDescription)
//                    completion(false)
//                }
//                else {
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
//            let password = userInformation["password"] as! String
            
            let currentUserRef = Database.database().reference().child("users").child(phone)
            let values = ["userType": userType, "name": name] as [String : Any]
            currentUserRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                }
                else {
                    completion(true)
                }
            })
            
        }
        else {
            completion(false)
        }
        
    }
    
    
    class func changePwd(newPassword: String, completion: @escaping (Bool) -> Swift.Void) {
        let newPassword = newPassword
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            //            let password = userInformation["password"] as! String
            
            let currentPasswordRef = Database.database().reference().child("users").child(phone)
            let values = ["password": newPassword]
            currentPasswordRef.setValue(values, withCompletionBlock: { (error, ref) in
                if let error = error {
                    // 发生错误
                    print(error.localizedDescription)
                    completion(false)
                }
                else {
                    completion(true)
                    UserDefaults.standard.set(newPassword, forKey: "password")
                }
            })
        }
        else {
            completion(false)
        }
    }
    
    class func loginUser(withPhone: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        
        
        let currentUserRef =  Database.database().reference().child("users").child(withPhone)
        
        //  读取key对应value使用以下方法
        currentUserRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let values = snapshot.value as? NSDictionary
            let userType = values!["userType"] as! Int
            let realPassword = values!["password"] as! String
            let name = values!["name"] as! String

            if password == realPassword {
                let userInfo = ["phone": withPhone, "password": password, "name": name, "userType" : userType] as [String : Any]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            }

            else {
                print("登录失败")
                completion(false)
            }
        })
        
        
        
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
//            try WDGAuth.auth()?.signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    //MARK: Inits
    init(name: String, password: String, phone: String, userID: String, profilePic: UIImage) {
        self.name = name
        self.password = password
        self.phone = phone
        self.userID = userID
        self.profilePic = profilePic
    }
}
