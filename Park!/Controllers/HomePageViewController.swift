//
//  HomePageViewController.swift
//  Park!
//
//  Created by Blaer on 21/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomePageViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet var  myScrollView: UIScrollView!
    
    func customization() {
        
        self.firstView.backgroundColor = FlatBlackDark()
        self.secondView.backgroundColor = FlatWhite()
        self.thirdView.backgroundColor = FlatWhite()
        self.fourthView.backgroundColor = FlatWhite()
        
    }

    func setupNavBar() {
        self.navigationItem.title = "主页"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = FlatWhite()
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize.init(width: 5, height: 5)
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.2
        self.navigationController?.hidesNavigationBarHairline = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.setupNavBar()
            self.myScrollView.contentInsetAdjustmentBehavior = .automatic
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
