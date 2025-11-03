//
//  MovieFinderApp.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/1/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MovieFinderApp: App {
    // MARK: - App Services
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var movieService = MovieService()
    @StateObject private var auth = AuthService.shared

    var body: some Scene {
        WindowGroup {
            if auth.currentUser != nil {
                MainView()
                    .environmentObject(movieService)
            } else {
                AuthGate()
                    .environmentObject(movieService)
            }
        }
    }
}
