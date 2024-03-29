//
//  AppDelegate.swift
//  Dependiject_Example
//
//  Created by William Baker on 03/31/2022.
//  Copyright (c) 2022 Tiny Home Consulting LLC. All rights reserved.
//

import UIKit
import Dependiject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        
        registerDependencies()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate {
    func registerDependencies() {
        Factory.register {
            Service(.transient, DataFetcher.self) { _ in
                DataFetcherImplementation()
            }
            
            Service(.transient, DataValidator.self) { _ in
                DataValidatorImplementation()
            }
            
            MultitypeService(exposedAs: [DataStateUpdater.self, DataStateAccessor.self]) { r in
                DataStateManagerImplementation()
            }
            
            Service(.weak, PrimaryViewModel.self) { r in
                PrimaryViewModelImplementation(
                    fetcher: r.resolve(),
                    validator: r.resolve(),
                    updater: r.resolve()
                )
            }
            
            Service(.weak, SecondaryViewModel.self) { r in
                SecondaryViewModelImplementation(
                    updater: r.resolve()
                )
            }
        }
    }
}
