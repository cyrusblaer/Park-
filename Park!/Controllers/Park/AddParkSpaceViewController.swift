//
//  AddParkSpaceViewController.swift
//  Park!
//
//  Created by Blaer on 16/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import DropDown

class AddParkSpaceViewController: UIViewController,  UITextFieldDelegate, UINavigationControllerDelegate,AMapSearchDelegate, MAMapViewDelegate {

    @IBOutlet weak var spaceInfoView: UIView!
    
    @IBOutlet weak var lotTextField: UITextField!
    
    @IBOutlet weak var lotViewSeperator: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var startRentSeg: UISegmentedControl!
    
    @IBOutlet var inputFields: [UITextField]!
    @IBOutlet var waringLabels: [UILabel]!
    
    var spaceInfoViewTopConstraint: NSLayoutConstraint!
    
    var isSpaceInfoViewVisible = true
    
    var amapSearch = AMapSearchAPI()
    var resultsName = Array<String>()
    var parkingLot : ParkingLot?
    var lotArr = Array<ParkingLot>()
    let dropDown = DropDown()
    
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
    
    func initAmap() {
        AMapServices.shared().enableHTTPS = true
        
        self.amapSearch?.delegate = self
        
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
            ParkingSpace.addParkingSpaceWith(ownerId: phone, lotId: (self.parkingLot?.uid)!, isReady: isReady, completion: { [weak weakSelf = self](status) in
                DispatchQueue.main.async {
                    if status {
                        weakSelf?.dismiss(animated: true, completion: nil)
                    }
                    else {
                        for item in (weakSelf?.waringLabels)! {
                            item.isHidden = false
                        }
                    }
                    weakSelf = nil
                }
                
            })
        }
        
    }
    
    @IBAction func closeVC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func pushTomainView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! RAMAnimatedTabBarController
        self.show(vc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.initAmap()
        dropDown.anchorView = self.lotViewSeperator
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.parkingLot = self.lotArr[index]
            self.dropDown.hide()
            self.lotTextField.text = item
        }
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
    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!)
    {
        let error = error
        NSLog((error?.localizedDescription)!)
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if response.count == 0 {
            return
        }
        resultsName.removeAll()
        for aPOI in response.pois {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            //            let enterLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.enterLocation.latitude), longitude: CLLocationDegrees(aPOI.enterLocation.longitude))
            let lot = ParkingLot.init(aPOI.uid, name: aPOI.name, address: aPOI.address, location: location, numberOfSpace: 0, rentNumber: 0, supervisorId: "", isRegistered: true)
            lot.city = aPOI.city
            
            lot.district = aPOI.district
            lotArr.append(lot)
            resultsName.append(aPOI.name)
            //            let anno = MAPointAnnotation()
            //            anno.coordinate = coordinate
            //            anno.title = aPOI.name
            //            anno.subtitle = aPOI.address
            //            annos.append(anno)
            //            resultsName.append(aPOI.name)
        }
        dropDown.dataSource = resultsName
        dropDown.show()
        
    }
}
