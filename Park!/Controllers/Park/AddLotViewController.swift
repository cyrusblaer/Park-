//
//  AddLotViewController.swift
//  Park!
//
//  Created by Blaer on 20/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD

class AddLotViewController: UIViewController {

    var amapSearch = AMapSearchAPI()
    var annos = Array<MAPointAnnotation>()
    var resultsName = Array<String>()
    
    @IBOutlet weak var lotNameTextField: UITextField!
    
    
    @IBOutlet weak var nameFieldSeperator: UIView!
    
    @IBOutlet weak var numberOfSpaceTextField: UITextField!
    @IBOutlet weak var supervisorPhoneTextField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet var inputFields: [UITextField]!
    
    var parkingLot : ParkingLot?
    var lotArr = Array<ParkingLot>()
    
    let dropDown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "车场信息登记"
        self.initAmap()
        dropDown.anchorView = self.nameFieldSeperator

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.parkingLot = self.lotArr[index]
            self.dropDown.hide()
            self.lotNameTextField.text = item
        }

        // Do any additional setup after loading the view.
    }
    
    func initAmap() {
        AMapServices.shared().enableHTTPS = true
        
        self.amapSearch?.delegate = self
        
    }

    func searchByKeyword(_ keyword: String!) {
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
        request.city = "广州"
        request.types = "停车场"
        
        request.cityLimit = true
        request.requireSubPOIs = true
        
        amapSearch?.aMapPOIKeywordsSearch(request)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        
        if let numberOfSpace = Int(self.numberOfSpaceTextField.text!) {
            if let supervisor = self.supervisorPhoneTextField.text {
                ParkingLot.registerParkingLot(withUid: (self.parkingLot?.uid)!, name: (self.parkingLot?.name)!, address: (self.parkingLot?.address)!, location: (self.parkingLot?.location)!, numberOfSpace: numberOfSpace, rentNumber: 0, supervisorId: supervisor) { [unowned self](status) in
                    if status {
                        SVProgressHUD.showSuccess(withStatus: "添加成功")
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        SVProgressHUD.showError(withStatus: "添加失败,请重试")
                    }
                }
            }
            else {
                SVProgressHUD.showError(withStatus: "请填写管理员手机号")
            }
            
        }
        else {
            SVProgressHUD.showError(withStatus: "请填写车位数量")
        }
        
    }
    
    
    @IBAction func closeVC(_ sender: Any) {
        
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

extension AddLotViewController: UITextFieldDelegate,AMapSearchDelegate, MAMapViewDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3 {
            
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.searchResultTableView.isHidden = false
//        self.searchByKeyword(textField.text!)
//        self.searchResultTableView.reloadData()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        for item in inputFields {
            item.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        for item in inputFields {
            item.resignFirstResponder()
        }
        if textField.tag == 3 {
            self.searchByKeyword(textField.text!)
            
        }
        else if textField.tag == 4
        {
            
        } else if textField.tag == 5 {
            
        }
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
        annos.removeAll()
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
