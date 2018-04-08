//
//  AccountInfoViewController.swift
//  Park!
//
//  Created by Blaer on 15/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import Photos

class AccountInfoViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var profileView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var userTypeView: UIView!
    
    @IBOutlet weak var profilePic: RoundedImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var oldPwdTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    @IBOutlet weak var userTypeSeg: UISegmentedControl!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet var waringLabels: [UILabel]!
    
    @IBOutlet var inputFields: [UITextField]!
    
    var profileViewTopConstraint: NSLayoutConstraint!
    var passwordViewTopConstraint: NSLayoutConstraint!
    var userTypeViewTopConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var isProfileViewVisible = true
    
    func customization() {
        self.imagePicker.delegate = self
        self.profilePic.layer.borderColor = GlobalVariables.blue.cgColor
        self.profilePic.layer.borderWidth = 2
        
        //ProfileView customization
        self.view.addSubview(self.profileView)
        self.profileView.translatesAutoresizingMaskIntoConstraints = false
        self.profileView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.profileViewTopConstraint = NSLayoutConstraint.init(item: self.profileView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 60)
        self.profileViewTopConstraint.isActive = true
        self.profileView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        self.profileView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.profileView.layer.cornerRadius = 8
        
        //PasswordView Customization
        self.view.insertSubview(self.passwordView, belowSubview: self.profileView)
        self.passwordView.translatesAutoresizingMaskIntoConstraints = false
        self.passwordView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.passwordViewTopConstraint = NSLayoutConstraint.init(item: self.passwordView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.passwordViewTopConstraint.isActive = true
        self.passwordView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        self.passwordView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.passwordView.layer.cornerRadius = 8
        //UserTypeView Customization
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let userName = userInformation["name"] as! String
            self.displayNameTextField.text = userName
            
        }
        else {
            self.displayNameTextField.text = ""
        }
        self.view.insertSubview(self.userTypeView, belowSubview: self.profileView)
        self.userTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.userTypeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.userTypeViewTopConstraint = NSLayoutConstraint.init(item: self.userTypeView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 1000)
        self.userTypeViewTopConstraint.isActive = true
        self.userTypeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        self.userTypeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.userTypeView.layer.cornerRadius = 8
    }
    
    func loadProfileInfo() {
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            self.phoneLabel.text = (userInformation["phone"] as! String)
            self.displayNameLabel.text = (userInformation["name"] as! String)
            if let userType = userInformation["userType"] as? Int {
                switch userType {
                case 3:
                    self.userTypeLabel.text = "管理员"
                case 2:
                    self.userTypeLabel.text = "物业公司"
                case 1:
                    self.userTypeLabel.text = "车位出租者"
                case 0:
                    self.userTypeLabel.text = "车位使用者"
                default:
                    self.userTypeLabel.text = ""
            }
            
            }
        }
    }
    
    @IBAction func resetPwdAction(_ sender: UIButton) {
        
        if self.isProfileViewVisible {
            self.isProfileViewVisible = false
            
            self.profileView.alpha = 0.0
            self.passwordView.alpha = 1.0
            self.profileViewTopConstraint.constant = 1000
            self.passwordViewTopConstraint.constant = 60
        } else {
            self.isProfileViewVisible = true
            
            self.profileView.alpha = 1.0
            self.passwordView.alpha = 0.0
            self.profileViewTopConstraint.constant = 60
            self.passwordViewTopConstraint.constant = 1000
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        for item in self.waringLabels {
            item.isHidden = true
        }
    }
    
    
    @IBAction func userInfoAction(_ sender: UIButton) {
        if self.isProfileViewVisible {
            self.isProfileViewVisible = false
            
            self.profileViewTopConstraint.constant = 1000
            self.userTypeViewTopConstraint.constant = 60
        } else {
            self.isProfileViewVisible = true
            
            self.profileViewTopConstraint.constant = 60
            self.userTypeViewTopConstraint.constant = 1000
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        for item in self.waringLabels {
            item.isHidden = true
        }
        
    }
    
    
    @IBAction func confirmChangePwd(_ sender: Any) {
        
        for item in self.inputFields {
            item.resignFirstResponder()
        }
        if self.oldPwdTextField.text != nil {
            User.changePwd(newPassword: self.newPwdTextField.text!, completion: { [weak weakSelf = self](state) in
                DispatchQueue.main.async {
//                    weakSelf?.showLoading(state: false)
                    for item in self.inputFields {
                        item.text = ""
                    }
                    if state {
                        // pop out
                        weakSelf?.dismiss(animated: true, completion: nil)
                    } else {
                        for item in (weakSelf?.waringLabels)! {
                            item.isHidden = false
                        }
                    }
                    weakSelf = nil
                }
            })
        }
        
    }
    
    @IBAction func confirmChangeUserInfo(_ sender: Any) {
        
        User.updateUserInfoWith(userType: self.userTypeSeg.selectedSegmentIndex, name: self.displayNameTextField.text!) { [weak weakSelf = self](state) in
            DispatchQueue.main.async {
                if state {
                    // pop out
                    weakSelf?.dismiss(animated: true, completion: nil)
                }
                else {
                    for item in (weakSelf?.waringLabels)! {
                        item.isHidden = false
                    }
                }
                weakSelf = nil
            }
            
        }
    }
    
    @IBAction func closeVC(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.customization()
        self.loadProfileInfo()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func openPhotoPickerWith(source: PhotoSource) {
        switch source {
        case .camera:
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        case .library:
            let status = PHPhotoLibrary.authorizationStatus()
            if (status == .authorized || status == .notDetermined) {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.profilePic.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
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
