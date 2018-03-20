//
//  AddLotViewController.swift
//  Park!
//
//  Created by Blaer on 20/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit

class AddLotViewController: UIViewController {

    var amapSearch = AMapSearchAPI()
    var annos = Array<MAPointAnnotation>()
    
    @IBOutlet weak var lotNameTextField: UITextField!
    @IBOutlet weak var numberOfSpaceTextField: UITextField!
    @IBOutlet weak var supervisorPhoneTextField: UITextField!
    
    @IBOutlet var inputFields: [UITextField]!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "车场信息登记"
        self.searchResultTableView.delegate = self
        self.searchResultTableView.dataSource = self
        self.initAmap()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddLotViewController: UITextFieldDelegate,AMapSearchDelegate, MAMapViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return annos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLotTableViewCell", for: indexPath) as! SearchLotTableViewCell
        
        cell.title = annos[indexPath.row].title
        
        return cell
    }
    
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
            self.searchResultTableView.isHidden = false
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
        
        for aPOI in response.pois {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            annos.append(anno)
        }
        self.searchResultTableView.reloadData()
    }
    
    
    
}
