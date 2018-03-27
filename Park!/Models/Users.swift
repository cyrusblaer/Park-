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
    let phone: String
    var profilePic: UIImage
    let userType: Int
    
    //MARK: Methods
    
    class func info(_ phone: String, completion: @escaping (User) -> Swift.Void) {
        Database.database().reference().child("users").child(phone).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let name = data["name"] as! String
                let phone = data["uid"] as! String
                let type = data["userType"] as! Int
                if let link = URL.init(string: data["profilePicLink"] as! String){
                    URLSession.shared.dataTask(with: link, completionHandler: { (data, response, error) in
                    if error == nil {
                        let profilePic = UIImage.init(data: data!)
                        let user = User.init(name: name, phone: phone, profilePic: profilePic!, userType: type)
                        completion(user)
                    }
                }).resume()
                }
            }
        })
    }
    
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

    class func updateUserInfoWith(userType: Int, name: String,  completion: @escaping (Bool) -> Swift.Void) {
        
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
        
        // need jump out when network fail
        
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
    init(name: String,  phone: String,  profilePic: UIImage, userType: Int) {
        self.name = name
        self.phone = phone
        self.profilePic = profilePic
        self.userType = userType
    }
}
