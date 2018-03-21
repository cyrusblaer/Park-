//
//  LandingViewController.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import ChameleonFramework

class LandingViewController: UIViewController {
    
    @IBOutlet weak var launchView: UIView!
    
    //MARK: Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    //MARK: Push to relevant ViewController
    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
        case .tabVC:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! RAMAnimatedTabBarController
            self.present(vc, animated: true, completion: nil)
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeNavVC") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        case .welcome:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! WelcomeViewController
            self.present(vc, animated: true, completion: nil)
        case .park:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ParkNavVC") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        case .account:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AccountNavVC") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        case .map:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapNavVC") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            let password = userInformation["password"] as! String
            User.loginUser(withPhone: phone, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .tabVC)
                    } else {
                        weakSelf?.pushTo(viewController: .welcome)
                    }
                    weakSelf = nil
                }
            })
        } else {
            self.pushTo(viewController: .welcome)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.launchView.backgroundColor = FlatOrange()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
