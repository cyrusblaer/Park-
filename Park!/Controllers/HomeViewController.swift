//
//  HomeViewController.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var startParkView: UIView!
    
    @IBOutlet weak var spaceIdInputTextField: UITextField!
    var startParkViewTopConstraint: NSLayoutConstraint!
    var isStartParkViewVisible = true
    
    func customization() {
        //startParkView customization
        self.view.addSubview(self.startParkView)
        self.startParkView.translatesAutoresizingMaskIntoConstraints = false
        self.startParkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startParkViewTopConstraint = NSLayoutConstraint.init(item: self.startParkView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.startParkViewTopConstraint.isActive = true
        self.startParkView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        self.startParkView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        self.startParkView.layer.cornerRadius = 8
    }
    
    @IBAction func startPark(_ sender: UIButton) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "主页"
        self.customization()
    }
    
    
}

// MARK: - Delegate

extension HomeViewController {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

