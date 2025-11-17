//
//  MainView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            MovieSearchView()
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            
            FavoriteView()
                .tabItem { Label("Favorites", systemImage: "heart.fill") }
            
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
        }

    }
}
