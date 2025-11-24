//
//  FavoriteView.swift
//  MovieFinder
//
//  Updated by Saimur Rashid on 2025-11-13.
//


import SwiftUI

import SwiftUI

struct FavoriteView: View {
    @StateObject private var favManager = FavoritesManager.shared

    var body: some View {
        NavigationView {
            List {
                if favManager.favorites.isEmpty {
                    Text("You don't have any favorites yet.")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(favManager.favorites) { movie in
                        NavigationLink(destination: MovieDetailView(imdbID: movie.imdbID)) {
                            MovieRowView(movie: movie)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Favorites")
        }
    }

    private func delete(_ index: IndexSet) {
        index.forEach { i in
            let movie = favManager.favorites[i]
            favManager.remove(movie)
        }
    }
}
