//
//  AppDelegate.swift
//  MeeTwo
//
//  Created by Trivedi Sagar on 18/10/16.
//  Copyright © 2016 Sagar Trivedi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var globalMethodObj = GlobalMethods()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        DBOperation.checkCreateDB()
        IQKeyboardManager.sharedManager().enable = true
        
        // For Push Notification check
        let settings = UIUserNotificationSettings.init(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    // MARK:For Push Notification
    private func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("DEVICE_TOKEN_DATA :: \(deviceToken.description)") // (SWIFT = 3):TOKEN PARSING
        let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        print(deviceTokenString)
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Sent when the application is about to move fro.m active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
//        loginManager.logOut()
    }
}
