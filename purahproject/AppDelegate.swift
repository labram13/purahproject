//
//  AppDelegate.swift
//  purahproject
//
//  Created by Michaelangelo Labrador on 5/20/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Set initial global font for UILabels
            UILabel.appearance().font = UIFont(name: "HyliaSerifBeta-Regular", size: 17)
            
            
            // Set initial global font for UINavigationBar title
            if let zeldaFont = UIFont(name: "HyliaSerifBeta-Regular", size: 27) {
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: zeldaFont,
                    .foregroundColor: UIColor.black // Change the color if needed
                ]
                UINavigationBar.appearance().titleTextAttributes = attributes
                UIButton.appearance().titleLabel?.font = zeldaFont
            }
            
            if let zeldaFont = UIFont(name: "HyliaSerifBeta-Regular", size: 17) {
                UITextView.appearance().font = zeldaFont
            }
            
            // Set initial global font for UIBarButtonItem
            let barButtonAppearance = UIBarButtonItem.appearance()
            let barButtonFontAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "HyliaSerifBeta-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
            ]
            barButtonAppearance.setTitleTextAttributes(barButtonFontAttributes, for: .normal)
            Thread.sleep(forTimeInterval: 3.0)
            
            return true
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

