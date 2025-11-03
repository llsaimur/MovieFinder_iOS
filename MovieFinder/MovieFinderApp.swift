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
    @StateObject private var movieService = MovieService()

    var body: some Scene {
        WindowGroup {
            MovieSearchView()
                .environmentObject(movieService)
        }
    }
}
