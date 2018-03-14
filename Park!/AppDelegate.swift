//
//  AppDelegate.swift
//  Park!
//
//  Created by Blaer on 23/02/2018.
//  Copyright © 2018 Blaer. All rights reserved.
//

import UIKit
import AMapFoundationKit
import Wilddog
import QCloudCore
import QCloudCOSXML

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //  高德地图初始化
        AMapServices.shared().apiKey = "17d6e6bfd8ff307c18483da6280cf1c6"
        //  WildDog初始化
        let options = WDGOptions.init(syncURL: "https://wd8986093797xenueg.wilddogio.com")
        WDGApp.configure(with: options)
        let auth = WDGAuth.auth()
        
        //  腾讯云对象存储初始化
        var configuration = QCloudServiceConfiguration()
        configuration.appID = "1254251493"
        configuration.signatureProvider = self as! QCloudSignatureProvider
        var endpoint = QCloudCOSXMLEndPoint()
        endpoint.regionName = "ap-guangzhou"
        configuration.endpoint = endpoint;
        
        QCloudCOSXMLService.registerDefaultCOSXML(with: configuration)
        QCloudCOSTransferMangerService.registerDefaultCOSTransferManger(with: configuration)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

