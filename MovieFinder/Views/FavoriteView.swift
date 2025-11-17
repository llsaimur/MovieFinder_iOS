//
//  FavoriteView.swift
//  MovieFinder
//
//  Updated by Saimur Rashid on 2025-11-13.
//


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
                } else {
                    ForEach(favManager.favorites) { movie in
                        NavigationLink {
                            MovieDetailView(imdbID: movie.imdbID)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: movie.poster)) { img in
                                    img.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 55, height: 85)
                                .cornerRadius(6)

                                VStack(alignment: .leading) {
                                    Text(movie.title)
                                    Text(movie.year)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
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
