//
//  AccountTableViewController.swift
//  Park!
//
//  Created by Blaer on 14/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework
import Hero

class AccountTableViewController: UITableViewController {

    var userType: Int!
    
    var normalUserTable : [String] = ["个人信息","消费记录","积分","设置","关于软件"]
    
    var ownerUserTable : [String] = ["个人信息","车位管理","消费记录","积分","设置","关于软件"]
    
    var adminUserTable: [String] = ["个人信息","设置","关于软件"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = FlatWhite()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let displayName = userInformation["name"] as! String
            self.userType = userInformation["userType"] as! Int
            self.navigationItem.title = "您好," + displayName
        }
        else {
            self.navigationItem.title = "您好"
        }
        
        self.setupNavBar()
        
        
    }
    
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.hidesNavigationBarHairline = true

    }
    
    @IBAction func callCustomerService(_ sender: Any) {
        
        let url = URL(string: "telprompt://+8618502093892")
        UIApplication.shared.openURL(url!)
    }
    
}
extension AccountTableViewController {
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as AccountTableViewCell = cell else {
            return
        }
        cell.backgroundColor = FlatWhite()
        if self.userType == 0 {
            cell.type = normalUserTable[indexPath.row]
        }else if self.userType == 2 || self.userType == 3 {
            cell.type = ownerUserTable[indexPath.row]
        } else {
            cell.type = adminUserTable[indexPath.row]
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.userType == 0 {
            return self.normalUserTable.count
        }else if self.userType == 2 || self.userType == 3 {
            return self.ownerUserTable.count
        } else {
            return adminUserTable.count
        }
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath)
     
        // Configure the cell...
        
        if indexPath.row == 0 {
            
        }
        
        return cell
     }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var usingTable : [String] = []
        
        if self.userType == 0 {
            usingTable = normalUserTable
        }else if self.userType == 2 || self.userType == 3 {
            usingTable = ownerUserTable
        } else {
            usingTable = adminUserTable
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        switch usingTable[indexPath.row] {
        case "个人信息":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfo") as! UIViewController
            vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.tabBarController?.present(vc, animated: true, completion: nil)
            
        case "消费记录":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecordNav") as! UINavigationController
            
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .push(direction: .left)
            
            self.present(vc, animated: true, completion: nil)
            
        case "积分":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClubNav") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        
        case "设置":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingNav") as! UINavigationController
            
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .push(direction: .left)
            self.present(vc, animated: true, completion: nil)
        
        case "车位管理":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkManageNav") as! UINavigationController
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .push(direction: .left)
            self.present(vc, animated: true, completion: nil)
            
        case "关于软件":
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! UIViewController
            self.present(vc, animated: true, completion: nil)
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClubVC") as! UIViewController
            
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let footer = UIView.init()
        
        return footer
        
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return false
     }
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
}
