//
//  Users.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import Foundation
import UIKit
import Wilddog

class User: NSObject {
    
    //MARK: Properties
    let name: String
    let email: String
    let phone: String
    let userID: String
    var profilePic: UIImage
    
    //MARK: Methods
    class func registerUser(withName: String, email: String, password: String, profilePic: UIImage, completion: @escaping (Bool) -> Swift.Void) {
        
        WDGAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                user?.sendEmailVerification(completion: nil)
                let values = ["name": withName, "email": email]
            WDGSync.sync().reference().child("users").child((user?.uid)!).child("credentials").updateChildValues(values, withCompletionBlock: { (errr, _) in
                    if errr == nil {
                        let userInfo = ["email" : email, "password" : password]
                        UserDefaults.standard.set(userInfo, forKey: "userInformation")
                        completion(true)
                    }
                })
                
            }
            
        })
        
    }
    
    /**
    //  get SMScode
    class func getSMSCodeWith(phone: String, password: String, completion: @escaping (WDGUser) -> Swift.Void) {
        WDGAuth.auth()?.createUser(withPhone: phone, password: password, completion: { (user, error) in
        
            if error == nil {
                user?.sendPhoneVerification(completion: nil)
                completion(user!)
            }
        })
    }

    
    //  verify SMScode
    class func verifySMSCodeWith(user: WDGUser, code: String, completion: @escaping (Bool) -> Swift.Void) {
        
        let verifyingUser = user
        
        verifyingUser.verifyPhone(withSmsCode: code) { (error) in
            if error == nil {
//                let userInfo = ["phone" : phone, "password" : password]
//                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            }
            else {
                user.delete(completion: { (error) in
                    if error != nil {
                        
                    }
                    else {
                        print("User verification failed")
                    }
                })
            }
        }
    }
    
    */
    
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
                
                let userInfo = ["phone" : phone, "password" : password, "displayName": withName]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            }
        })
        
    }
    
    class func createUserInDatabaseWith(uid: String, phone: String, userType: Int, completion: @escaping (Bool) -> Swift.Void) {
        let usersRef = WDGSync.sync().reference().child("users")
        
        if usersRef.accessibilityElementCount() == 0 {
            WDGSync.sync().reference().setValue(["users" : nil])
        }
        
        let userInfo = [phone : ["uid": uid, "userType": userType]]
        
        usersRef.setValue(userInfo) { (error, ref) in
            if error == nil {
                completion(true)
            }
            else {
                 completion(false)
            }
        }
    }
    
    class func updateUserInfoWith(userType: Int, name: String, completion: @escaping (Bool) -> Swift.Void) {
        let currentUser = WDGAuth.auth()?.currentUser
        if let user = currentUser {
            let changeRequest = user.profileChangeRequest()
            changeRequest.displayName = name
            //                    changeRequest.photoURL =
            //                        NSURL(string: "https://example.com/jane-q-user/profile.jpg") as URL?
            changeRequest.commitChanges { error in
                if let error = error {
                    // 发生错误
                    print(error.localizedDescription)
                    completion(false)
                }
                else {
                    let currentUserRef = WDGSync.sync().reference().child("users").child((currentUser?.phone)!)
                    let values = ["userType": userType]
                    currentUserRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            // 发生错误
                            print(error.localizedDescription)
                            completion(false)
                        }
                        else {
                            completion(true)
                        }
                    })
                    
                }
            }
        }
    }
    
    class func changePwd(newPassword: String, completion: @escaping (Bool) -> Swift.Void) {
        let user = WDGAuth.auth()?.currentUser
        let newPassword = newPassword
        user?.updatePassword(newPassword) { error in
            if let error = error {
                // 发生错误
                print(error.localizedDescription)
                completion(false)
            } else {
                // 更新成功
                print("Password update success")
                completion(true)
            }
        }
    }
    
    class func loginUser(withPhone: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        
        WDGAuth.auth()?.signIn(withPhone: withPhone, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["phone": withPhone, "password": password, "displayName": user?.displayName]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
        
    }
    
    class func loginUser(withEmail: String, password: String, completion: @escaping (Bool) -> Swift.Void) {
        WDGAuth.auth()?.signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            if error == nil {
                let userInfo = ["email": withEmail, "password": password]
                UserDefaults.standard.set(userInfo, forKey: "userInformation")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    class func logOutUser(completion: @escaping (Bool) -> Swift.Void) {
        do {
            try WDGAuth.auth()?.signOut()
            UserDefaults.standard.removeObject(forKey: "userInformation")
            completion(true)
        } catch _ {
            completion(false)
        }
    }
    
    //MARK: Inits
    init(name: String, email: String, phone: String, userID: String, profilePic: UIImage) {
        self.name = name
        self.email = email
        self.phone = phone
        self.userID = userID
        self.profilePic = profilePic
    }
}
