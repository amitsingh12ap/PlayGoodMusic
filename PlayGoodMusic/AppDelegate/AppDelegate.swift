//
//  AppDelegate.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
//import IQKeyboardManager
import GoogleCast
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GCKLoggerDelegate {
    var window: UIWindow?
    let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    let kDebugLoggingEnabled = true
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        TNAuthenticationManager.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
//        IQKeyboardManager.shared().isEnabled = true
        
        let castoptions = GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: kReceiverAppID))
        castoptions.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(castoptions)


        let logFilter = GCKLoggerFilter()
        logFilter.minimumLevel = .verbose
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
        
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "ede26cbf-f0e8-4f18-ac90-bc292978a722",
          handleNotificationAction: nil,
          settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        
        //END OneSignal initializataion code
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController:UINavigationController = mainstoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        window.rootViewController = navController
        self.window = window
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    // MARK: - GCKLoggerDelegate

      func logMessage(_ message: String,
                      at level: GCKLoggerLevel,
                      fromFunction function: String,
                      location: String) {
        if (kDebugLoggingEnabled) {
          print(function + " - " + message)
        }
      }
}

