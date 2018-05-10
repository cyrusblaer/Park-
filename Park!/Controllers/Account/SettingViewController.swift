//
//  SettingViewController.swift
//  Park!
//
//  Created by Blaer on 23/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework

class SettingViewController: UIViewController {

    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logoutButton = UIButton.init(frame: CGRect.init(x: self.view.bounds.width/2 - 100, y: GlobalVariables.kScreenHeight - 109 - 96 - 40 - 20, width: 200, height: 40))
        self.logoutButton.titleLabel?.font = UIFont.init(name: "Avenir Book", size: 17)
        self.logoutButton.setTitle("退出登录", for: .normal)
        self.logoutButton.setTitleColor(.white, for: .normal)
        self.logoutButton.backgroundColor = FlatRed()
        self.logoutButton.layer.cornerRadius = 4
        self.logoutButton.addTarget(self, action: #selector(logoutButtonAction(button:)), for: .touchUpInside)
        
        self.view.addSubview(self.logoutButton)
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.hero.modalAnimationType = .push(direction: .right)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func logoutButtonAction(button: UIButton) {
        
        User.logOutUser { [weak weakSelf = self](state) in
            DispatchQueue.main.async {
                if state {
                    weakSelf?.pushToWelcomeVC()
                }
                else {
                    print("Log out error")
                }
            }
        }
        
    }
    
    func pushToWelcomeVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! UIViewController
        self.present(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
