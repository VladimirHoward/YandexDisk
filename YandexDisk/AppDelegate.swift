//
//  AppDelegate.swift
//  YandexDisk
//
//  Created by Gregory House on 25.02.17.
//  Copyright © 2017 vvz. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        let shouldLogin = YADLoginManager.sharedInstance.shouldLogin()
        
        var initialVCID = ""
        
        if ( shouldLogin )
        {
            initialVCID = YADConst.UIConsts.kLoginScreenIdentifier
        }
        else
        {
            initialVCID = YADConst.UIConsts.kTabbarScreenIdentifier
        }
        
        let initialVC = YADViewControllerFabric.getViewController(withIdentifier: initialVCID)
        
        
        self.window?.rootViewController = initialVC
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
        return true
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        YADCoreDataManager.sharedInstance.save()
        
    }
    
}

