//
//  AppDelegate.swift
//  FoodAI
//
//  Created by Pablo on 2/18/17.
//  Copyright © 2017 Pablo Carvalho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        assert(Settings.cloudName.characters.count > 0, "PLEASE EDIT SETTINGS FILE ACCORDINGLY")
        assert(Settings.apiKey.characters.count > 0, "PLEASE EDIT SETTINGS FILE ACCORDINGLY")
        assert(Settings.apiSecret.characters.count > 0, "PLEASE EDIT SETTINGS FILE ACCORDINGLY")
        
        return true
    }

}

