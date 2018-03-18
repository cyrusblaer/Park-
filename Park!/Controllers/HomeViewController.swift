//
//  HomeViewController.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var startParkView: UIView!
    @IBOutlet weak var parkTimeView: UIView!
    
    
    @IBOutlet weak var parkTimeLabel: UILabel!
    @IBOutlet weak var spaceIdInputTextField: UITextField!
    var startParkViewTopConstraint: NSLayoutConstraint!
    var parkTimeViewTopConstraint: NSLayoutConstraint!
    
    var isStartParkViewVisible = true
    
    func customization() {
        //startParkView customization
        self.view.addSubview(self.startParkView)
        self.startParkView.translatesAutoresizingMaskIntoConstraints = false
        self.startParkView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.startParkViewTopConstraint = NSLayoutConstraint.init(item: self.startParkView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.startParkViewTopConstraint.isActive = true
        self.startParkView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        self.startParkView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        self.startParkView.layer.cornerRadius = 8
        
        //parkTimeView customization
        self.view.insertSubview(self.parkTimeView, belowSubview: self.startParkView)
        self.parkTimeView.translatesAutoresizingMaskIntoConstraints = false
        self.parkTimeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.parkTimeViewTopConstraint = NSLayoutConstraint.init(item: self.parkTimeView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.parkTimeViewTopConstraint.isActive = true
        self.parkTimeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0).isActive = true
        self.parkTimeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
        self.parkTimeView.layer.cornerRadius = 8
    }
    
    func showLoading(state: Bool)  {
        if state {
            self.darkView.isHidden = false
            self.spinner.startAnimating()
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0.5
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.darkView.alpha = 0
            }, completion: { _ in
                self.spinner.stopAnimating()
                self.darkView.isHidden = true
            })
        }
    }
    
    @IBAction func startPark(_ sender: UIButton) {
        
        if self.isStartParkViewVisible {
            self.isStartParkViewVisible = false
            self.startParkViewTopConstraint.constant = 1000
            self.parkTimeViewTopConstraint.constant = 60
            self.showLoading(state: true)
            
            // create new order
            
        } else {
            self.isStartParkViewVisible = true
            self.startParkViewTopConstraint.constant = 60
            self.parkTimeViewTopConstraint.constant = 1000
            
            // stop the clock and check
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
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

