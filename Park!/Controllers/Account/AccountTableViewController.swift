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
    
    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.view.backgroundColor = FlatWhite()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let displayName = userInformation["name"] as! String
            self.navigationItem.title = "您好," + displayName
        }
        else {
            self.navigationItem.title = "您好"
        }
        
        self.setupNavBar()
        
        self.logoutButton = UIButton.init(frame: CGRect.init(x: self.view.bounds.width/2 - 100, y: GlobalVariables.kScreenHeight - 109 - 96 - 40 - 20, width: 200, height: 40))
        self.logoutButton.titleLabel?.font = UIFont.init(name: "Avenir Book", size: 17)
        self.logoutButton.setTitle("退出登录", for: .normal)
        self.logoutButton.setTitleColor(.white, for: .normal)
        self.logoutButton.backgroundColor = FlatRed()
        self.logoutButton.layer.cornerRadius = 4
        self.logoutButton.addTarget(self, action: #selector(logoutButtonAction(button:)), for: .touchUpInside)
        
        self.view.addSubview(self.logoutButton)
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.hidesNavigationBarHairline = true

    }
    
    @objc func logoutButtonAction(button: UIButton) {
        
        User.logOutUser { [weak weakSelf = self](state) in
            if state {
                weakSelf?.pushToWelcomeVC()
            }
            else {
                print("Log out error")
            }
        }
        
    }
    
    func pushToWelcomeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    
}
extension AccountTableViewController {
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as AccountTableViewCell = cell else {
            return
        }
        cell.backgroundColor = FlatWhite()
        cell.type = indexPath.row
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath)
     
        // Configure the cell...
        
        if indexPath.row == 0 {
            
        }
        
        return cell
     }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "userInfo") as! UIViewController
            vc.modalPresentationStyle = .overFullScreen
            
            self.navigationController?.tabBarController?.present(vc, animated: true, completion: nil)
            
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecordNav") as! UINavigationController
            
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .push(direction: .left)
            
            self.present(vc, animated: true, completion: nil)
            
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ClubNav") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingNav") as! UINavigationController
            
            vc.hero.isEnabled = true
            vc.hero.modalAnimationType = .push(direction: .left)
            self.present(vc, animated: true, completion: nil)
        
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! UIViewController
            self.present(vc, animated: true, completion: nil)
        default:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RedView") as! UIViewController
            
            DispatchQueue.main.async {
                self.present(vc, animated: true, completion: nil)
            }
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
