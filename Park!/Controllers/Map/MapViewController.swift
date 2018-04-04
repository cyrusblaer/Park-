//
//  MapVC.swift
//  Park!
//
//  Created by Blaer on 12/03/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import ChameleonFramework
import MapKit

class MapViewController: UIViewController {
    
    var searchController: UISearchController!
    var mapView : MAMapView!
    var amapSearch = AMapSearchAPI()
    var destinationTitle: String = ""
    var optionMenu = UIAlertController()
    
    @IBOutlet var locateButton: RoundedButton!
    var locateButtonTopConstraint: NSLayoutConstraint!
    
    func customization() {
        self.view.insertSubview(self.locateButton, aboveSubview: self.mapView)
        self.locateButton.translatesAutoresizingMaskIntoConstraints = false
        self.locateButtonTopConstraint = NSLayoutConstraint.init(item: self.locateButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 60)
        self.locateButtonTopConstraint.isActive = true
//        self.locateButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.45).isActive = true
//        self.locateButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        self.locateButton.layer.cornerRadius = 8
        
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.definesPresentationContext = true
        
        self.initSearchController()
        self.initAmap()
        
        self.setupNavBar()
        
        self.view.bringSubview(toFront: self.locateButton)

    }

    func initSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "查找指定车场"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = true
        
        self.navigationItem.searchController = searchController
    }
    
    func initAmap() {
        AMapServices.shared().enableHTTPS = true
        self.mapView = MAMapView(frame: self.view.bounds)
        self.mapView.isShowsUserLocation = true
        self.mapView.userTrackingMode = .follow
        self.mapView.delegate = self
        self.amapSearch?.delegate = self
        
        self.view.addSubview(self.mapView)
        
    }
    
    @IBAction func locateCurrentLocation(_ sender: Any) {
        
        searchNearbyLots()
    }
    
    
}

extension MapViewController : UISearchBarDelegate,UISearchResultsUpdating, AMapSearchDelegate, MAMapViewDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchByKeyword(searchBar.text!)
        
        searchController.resignFirstResponder()
        
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
    
    func searchNearbyLots() {
        let request = AMapPOIAroundSearchRequest()
        
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(self.mapView.userLocation.coordinate.latitude), longitude: CGFloat(self.mapView.userLocation.coordinate.longitude))
        request.types = "停车场"
        request.keywords = "停车场"
        request.requireExtension = true
        
        amapSearch?.aMapPOIAroundSearch(request)
    }
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        print("name: \(String(describing: view.annotation.title))")
        
        self.destinationTitle = view.annotation.title!
        
        self.creatOptionMenu()
        
        self.present(self.optionMenu, animated: true, completion: nil)
        
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            return annotationView!
        }
        
        return nil
    }
    
    
    func creatOptionMenu(){
        optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if(UIApplication.shared.canOpenURL(URL(string: "qqmap://")!) == true){
            let qqAction = UIAlertAction(title: "腾讯地图", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let urlString = "qqmap://map/routeplan?from=我的位置&type=drive&tocoord=\(self.mapView.userLocation.coordinate.latitude),\(self.mapView.userLocation.coordinate.longitude)&to=\(self.destinationTitle)&coord_type=1&policy=0"
                let url = URL(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                UIApplication.shared.openURL(url!)
                
            })
            optionMenu.addAction(qqAction)
        }
        
        if(UIApplication.shared.canOpenURL(URL(string: "iosamap://")!) == true){
            let gaodeAction = UIAlertAction(title: "高德地图", style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                let urlString = "iosamap://navi?sourceApplication=app名&backScheme=iosamap://&lat=\(self.mapView.userLocation.coordinate.latitude)&lon=\(self.mapView.userLocation.coordinate.longitude)&dev=0&style=2"
                let url = URL(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
                
                UIApplication.shared.openURL(url!)
            })
            optionMenu.addAction(gaodeAction)
        }
        
        
        let appleAction = UIAlertAction(title: "苹果地图", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let loc = self.mapView.userLocation.coordinate
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:loc,addressDictionary:nil))
            toLocation.name = self.destinationTitle
            MKMapItem.openMaps(with: [currentLocation,toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: NSNumber(value: true)])
            
        })
        optionMenu.addAction(appleAction)
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        optionMenu.addAction(cancelAction)
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
        
        mapView.removeAnnotations(mapView.annotations)
        var annos = Array<MAPointAnnotation>()
        
        for aPOI in response.pois {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            annos.append(anno)
        }
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: false)
        mapView.selectAnnotation(annos.first, animated: true)
    }
    
    
    
}
