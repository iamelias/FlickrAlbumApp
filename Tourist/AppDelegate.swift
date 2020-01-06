//
//  AppDelegate.swift
//  Tourist
//
//  Created by Elias Hall on 10/26/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataController = DataController(modelName: "Tourist")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        print("Accessed AppDelegate")
        let navigationController = window?.rootViewController as! UINavigationController
        let touristLocations = navigationController.topViewController as! TouristLocationsController
        
        touristLocations.dataController = dataController
        dataController.load()
        return true
    }
}
    

