//
//  SceneDelegate.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 14/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import UIKit
//import IQKeyboardManager
import GoogleCast

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate,GCKLoggerDelegate {

    var window: UIWindow?
    let kReceiverAppID = kGCKDefaultMediaReceiverApplicationID
    let kDebugLoggingEnabled = true

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
//        IQKeyboardManager.shared().isEnabled = true
        
        let castoptions = GCKCastOptions(discoveryCriteria: GCKDiscoveryCriteria(applicationID: kReceiverAppID))
        castoptions.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(castoptions)


        let logFilter = GCKLoggerFilter()
        logFilter.minimumLevel = .verbose
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self

        guard let _ = (scene as? UIWindowScene) else { return }
        
    }
    
    // MARK: - GCKLoggerDelegate

    func logMessage(_ message: String,
                    at level: GCKLoggerLevel,
                    fromFunction function: String,
                    location: String) {
      if (kDebugLoggingEnabled) {
        print(function + " - " + message)
      }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}

