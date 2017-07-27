//
//  AppDelegate.swift
//  Qismet
//
//  Created by Lalit on 10/02/17.
//  Copyright © 2017 Qismet. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?

    var isReachable = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupReachability()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "TDLoginVC") as! TDLoginVC
        navController = UINavigationController(rootViewController: initialViewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func logOut(){
        
        UserDefaults.standard.set(false, forKey: KisRemember)
        UserDefaults.standard.set(false, forKey: KUserDefaultsProfilecompleted)
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async(execute: {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TDLoginVC") as! TDLoginVC
            self.navController = UINavigationController(rootViewController: initialViewController)
            self.window?.rootViewController = self.navController
        })

    }
    
    fileprivate func setupReachability() {
        
        // Allocate a reachability object
        let reach = Reachability.forInternetConnection()
        self.isReachable = (reach?.isReachable())!
        
        // Set the blocks
        
        reach?.reachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = true
            })
        }
        
        reach?.unreachableBlock = { (reachability) in
            
            DispatchQueue.main.async(execute: {
                self.isReachable = false
            })
        }
        
        reach?.startNotifier()
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

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

