//
//  ClubViewController.swift
//  Park!
//
//  Created by Blaer on 23/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework

class ClubViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var usedLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var backgroudStatusBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        
        self.navigationController?.navigationBar.backgroundColor = FlatGrayDark()
        self.backgroundView.backgroundColor = FlatBlackDark()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
