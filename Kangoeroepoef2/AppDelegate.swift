//
//  AppDelegate.swift
//  Kangoeroepoef2
//
//  Created by thomas de wulf on 16/01/17.
//  Copyright © 2017 thomas de wulf. All rights reserved.
//
// Sources:
// Realm: https://realm.io/docs/swift/latest/#getting-started
// Timestamp: http://stackoverflow.com/questions/2997062/how-to-convert-nsdate-into-unix-timestamp-iphone-sdk
//user defaults: http://stackoverflow.com/questions/19206762/equivalent-to-shared-preferences-in-ios


import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var updateService = UpdateService()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       
        // Override point for customization after application launch.
        
        //let user = RealmService.realm.objects(ApplicationUser.self).first!
        //print(user.consumpties)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        updateService.startReachabilityNotifier()
        APIService.getUserData()
        APIService.getDrankData()
        APIService.getOrderData()
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
       // APIService.getDrankData()
        //deze calls naar background verplaatsen. Is niet essentieel voor werking app
        let reachability = Reachability()!
        if reachability.isReachable {
            APIService.getDrankData()
            APIService.getUserData()
            APIService.getOrderData()
            APIService.pushOrders()
        }
      

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

