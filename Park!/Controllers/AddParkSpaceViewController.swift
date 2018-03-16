//
//  AddParkSpaceViewController.swift
//  Park!
//
//  Created by Blaer on 16/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

class AddParkSpaceViewController: UIViewController,  UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var spaceInfoView: UIView!
    
    @IBOutlet weak var lotTextField: UITextField!
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var startRentSeg: UISegmentedControl!
    
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet var waringLabels: [UILabel]!
    
    var spaceInfoViewTopConstraint: NSLayoutConstraint!
    
    var isSpaceInfoViewVisible = true
    
    func customization() {
        //ProfileView customization
        self.view.addSubview(self.spaceInfoView)
        self.spaceInfoView.translatesAutoresizingMaskIntoConstraints = false
        self.spaceInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.spaceInfoViewTopConstraint = NSLayoutConstraint.init(item: self.spaceInfoView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.spaceInfoViewTopConstraint.isActive = true
        self.spaceInfoView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        self.spaceInfoView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        self.spaceInfoView.layer.cornerRadius = 8
    }
    
    
    @IBAction func confirmAddParkSpace(_ sender: UIButton) {
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            var isReady = false
            if self.startRentSeg.selectedSegmentIndex == 0 {
                isReady = true
            }
            else {
                isReady = false
            }
            ParkingSpace.addParkingSpaceWith(ownerId: phone, lotId: self.lotTextField.text!, isReady: isReady, completion: { [weak weakSelf = self](status) in
                if status {
                    weakSelf?.dismiss(animated: true, completion: nil)
                }
                else {
                    for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }
                }
                weakSelf = nil
            })
        }
        
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! RAMAnimatedTabBarController
        self.show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
