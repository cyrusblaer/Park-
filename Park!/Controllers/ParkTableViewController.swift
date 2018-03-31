//
//  ParkManagerViewController.swift
//  Park!
//
//  Created by Blaer on 13/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import FoldingCell
import MJRefresh
import ChameleonFramework

class ParkTableViewController: UIViewController {
    
    @IBOutlet weak var foldingTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 15
    var cellHeights: [CGFloat] = []
    
    var currentUser: User?
    var currentLocation: CLLocationCoordinate2D?
    
    var amapSearch = AMapSearchAPI()
    
    var lotArr = Array<ParkingLot>()
    var nearbyLotArr = Array<ParkingLot>()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            User.info(phone) { (user) in
                self.currentUser = user
            }
        }
        setup()
        self.initAmap()
        self.locationManager.delegate = self
        
        self.navigationItem.title = "车位信息"
        
        self.headerRefresh()
    }
    
    func checkLocationPermission() -> Bool {
        var state = false
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            state = true
        case .authorizedAlways:
            state = true
        default: break
        }
        return state
    }
    
    func initAmap() {
        AMapServices.shared().enableHTTPS = true
        self.amapSearch?.delegate = self
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        self.foldingTableView.estimatedRowHeight = kCloseCellHeight
        self.foldingTableView.rowHeight = UITableViewAutomaticDimension
        self.foldingTableView.backgroundColor = UIColor.init(hexString: "ECF3F9")
        // 下拉刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(self.headerRefresh))
        // 现在的版本要用mj_header
        self.foldingTableView.mj_header = header
        
//         self.shyNavBarManager.scrollView = self.foldingTableView;
        
    }
    @IBAction func addSpaceAction(_ sender: Any) {
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let userType = userInformation["userType"] as! Int
            
            if userType == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddSpaceVC") as! AddParkSpaceViewController
                self.present(vc, animated: true, completion: nil)
            }
            else if userType == 2 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLotVC") as! AddLotViewController
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
    
    func pushToAddSpaceVC() {
        
    }
    
    @objc func headerRefresh(){
        print("下拉刷新")
        
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
    
//    // 底部刷新
//    var index = 0
//    func footerRefresh(){
//        print("上拉刷新")
//        self.foldingTableView.mj_footer.endRefreshing()
//        // 2次后模拟没有更多数据
//        index = index + 1
//        if index > 2 {
//            footer.endRefreshingWithNoMoreData()
//        }
//    }
    
}

// MARK: - TableView

extension ParkTableViewController: UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, CLLocationManagerDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        
        return self.nearbyLotArr.count
    }
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as HomeTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
//        cell.number = indexPath.row
        cell.name = self.nearbyLotArr[indexPath.row].name
        cell.address = self.nearbyLotArr[indexPath.row].address
        cell.city = self.nearbyLotArr[indexPath.row].city
        cell.district = self.nearbyLotArr[indexPath.row].district
        cell.isRegistered = self.nearbyLotArr[indexPath.row].isRegistered
        cell.distanceLabel.text = self.distanceToString(distance: self.nearbyLotArr[indexPath.row].distanceFromLocation)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    //MARK: - AMapSearchDelegate
    
    func searchNearbyLots() {
        let request = AMapPOIAroundSearchRequest()
        
        request.location = AMapGeoPoint.location(withLatitude: CGFloat((self.currentLocation?.latitude)!), longitude: CGFloat((self.currentLocation?.longitude)!))
        request.types = "停车场"
        request.keywords = "停车场"
        request.requireExtension = true
        
        amapSearch?.aMapPOIAroundSearch(request)
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!)
    {
        let error = error
        NSLog((error?.localizedDescription)!)
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count == 0 {
            return
        }
        print("number of response : \(response.pois.count)")
        
        self.nearbyLotArr.removeAll()
        
        for aPOI in response.pois {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            //            let enterLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.enterLocation.latitude), longitude: CLLocationDegrees(aPOI.enterLocation.longitude))
            let lot = ParkingLot.init(aPOI.uid, name: aPOI.name, address: aPOI.address, location: location, numberOfSpace: 0, rentNumber: 0, supervisorId: "", isRegistered: false)
            
            lot.city = aPOI.city
            
            lot.district = aPOI.district
            
            ParkingLot.searchLotInDatabase(aPOI.uid, completion: { (exist, existLot) in
                if exist {
                    existLot?.distanceFromLocation = self.calculateDistanceToCurrentLocation(self.currentLocation!, to: (existLot?.location)!)

                    self.nearbyLotArr.append(existLot!)
                    
                }
                else {
                    lot.distanceFromLocation = self.calculateDistanceToCurrentLocation(self.currentLocation!, to: lot.location)
                    
                    self.nearbyLotArr.append(lot)
                }
                
                print("array number: \(self.nearbyLotArr.count)")
                
//                if self.nearbyLotArr.count == response.pois.count {
                    self.cellHeights = Array(repeating: self.kCloseCellHeight, count: self.nearbyLotArr.count)
                    self.foldingTableView.reloadData()
                    self.foldingTableView.mj_header.endRefreshing()
                    
//                }
                
            })
            
            
//            let anno = MAPointAnnotation()
//            anno.coordinate = coordinate
//            anno.title = aPOI.name
//            anno.subtitle = aPOI.address
//            annos.append(anno)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let lastLocation = locations.last {
            currentLocation = lastLocation.coordinate
            let locationAge = -lastLocation.timestamp.timeIntervalSinceNow
            if locationAge > 1.0 {
                return
            }
            
            else {
                self.searchNearbyLots()
            }
        }
    }
    
    func calculateDistanceToCurrentLocation(_ from : CLLocationCoordinate2D, to : CLLocationCoordinate2D) -> CLLocationDistance{
        let from = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: 39.989612, longitude: 116.480972))
        let to = MAMapPointForCoordinate(CLLocationCoordinate2D(latitude: 39.990347, longitude: 116.480441))
    
        let distance = MAMetersBetweenMapPoints(from, to);
        
        return distance
    }
    
    func distanceToString (distance : CLLocationDistance) -> String {
        var distanceString = ""
        
        if distance / 1000.0 > 1 {
            distanceString = String.init(format: "%.1fkm", distance / 1000.0)
        } else {
            distanceString = String.init(format: "%dm", Int(distance))
        }
        
        return distanceString
    }
}

