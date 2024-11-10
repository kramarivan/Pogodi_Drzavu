//
//  AppDelegate.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 07.05.2024..
//

import SwiftUI
import GoogleMaps
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("?")
        FirebaseApp.configure()
        
        return true
    }
}
