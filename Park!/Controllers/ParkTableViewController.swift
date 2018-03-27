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
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    var currentUser: User?
    var currentLocation: CLLocationCoordinate2D?
    
    var amapSearch = AMapSearchAPI()
    
    var lotArr = Array<ParkingLot>()
    var nearbyLotArr = Array<ParkingLot>()
    
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    // 底部刷新
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let phone = userInformation["phone"] as! String
            User.info(phone) { (user) in
                self.currentUser = user
            }
        }
        self.searchNearbyLots()
        setup()
        self.initAmap()
        self.locationManager.delegate = self
        
        if self.checkLocationPermission() {
            self.locationManager.startUpdatingLocation()
        } else {
            self.locationManager.requestWhenInUseAuthorization()
        }
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
        header.setRefreshingTarget(self, refreshingAction: Selector(("headerRefresh")))
        // 现在的版本要用mj_header
        self.foldingTableView.mj_header = header
        
        // 上拉刷新
        footer.setRefreshingTarget(self, refreshingAction: Selector(("footerRefresh")))
        self.foldingTableView.mj_footer = footer
        
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
    
    func headerRefresh(){
        print("下拉刷新")
        // 结束刷新
        self.foldingTableView.mj_header.endRefreshing()
    }
    
    // 底部刷新
    var index = 0
    func footerRefresh(){
        print("上拉刷新")
        self.foldingTableView.mj_footer.endRefreshing()
        // 2次后模拟没有更多数据
        index = index + 1
        if index > 2 {
            footer.endRefreshingWithNoMoreData()
        }
    }
    
}

// MARK: - TableView

extension ParkTableViewController: UITableViewDelegate, UITableViewDataSource, AMapSearchDelegate, CLLocationManagerDelegate {
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return nearbyLotArr.count
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
        
        cell.number = indexPath.row
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
        
        for aPOI in response.pois {
            let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            //            let enterLocation = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.enterLocation.latitude), longitude: CLLocationDegrees(aPOI.enterLocation.longitude))
            let lot = ParkingLot.init(aPOI.uid, name: aPOI.name, address: aPOI.address, location: location, numberOfSpace: 0, rentNumber: 0, supervisorId: "", isRegistered: false)
            
            ParkingLot.searchLotInDatabase(aPOI.uid, completion: { (exist, existLot) in
                if exist {
                    self.nearbyLotArr.append(existLot!)
                }
                else {
                    self.nearbyLotArr.append(lot)
                }
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
        }
    }
}

