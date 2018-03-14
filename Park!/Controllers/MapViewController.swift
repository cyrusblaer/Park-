//
//  MapViewController.swift
//  Park!
//
//  Created by Blaer on 12/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func logoutAction(_ sender: Any) {
        
        User.logOutUser { (true) in
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AMapServices.shared().enableHTTPS = true
        
        let mapView = MAMapView(frame: self.view.bounds)
        // mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        self.view.addSubview(mapView)
        self.view.addSubview(logoutButton)

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
