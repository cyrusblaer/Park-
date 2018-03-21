//
//  HomePageViewController.swift
//  Park!
//
//  Created by Blaer on 21/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {

    @IBOutlet var  myScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "主页"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.largeTitleDisplayMode = .never
        
            self.myScrollView.contentInsetAdjustmentBehavior = .automatic
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
