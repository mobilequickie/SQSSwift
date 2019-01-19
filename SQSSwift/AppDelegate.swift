//
//  AppDelegate.swift
//  SQSSwift
//
//  Created by Hills, Dennis on 1/18/19.
//  Copyright © 2018 Hills, Dennis. All rights reserved.
//
//  See my deep dive blog into SQS as an event source: https://dzone.com/articles/amazon-sqs-as-an-event-source-to-aws-lambda-a-deep

import UIKit
import AWSMobileClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // AWS SDK logging and debugging
        AWSDDLog.sharedInstance.logLevel = .debug // set to .off for production
        AWSDDLog.add(AWSDDTTYLogger.sharedInstance) // Log to console (TTY = Xcode console)
        
        // Initialize the AWSMobileClient (used for identity management by AWS SDK)
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
}

