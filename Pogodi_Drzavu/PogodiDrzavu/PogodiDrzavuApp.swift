//
//  PogodiDrzavuApp.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 23.04.2024..
//

import SwiftUI

@main
struct PogodiDrzavuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            WelcomeView()
        }
    }
}
