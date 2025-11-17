//
//  MovieDetailView.swift
//  MovieFinder
//
//  Updated by Saimur Rashid on 2025-11-13
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel = MovieDetailViewModel()
    @StateObject private var favoritesManager = FavoritesManager.shared
    let imdbID: String

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading movie info...")
                Spacer()
            } else if let error = viewModel.errorMessage {
                Spacer()
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                Button("Retry") {
                    Task { await viewModel.fetchMovieDetail(imdbID: imdbID) }
                }
                .padding(.top, 8)
                Spacer()
            } else if let movie = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        // Poster
                        AsyncImage(url: URL(string: movie.poster)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                                .cornerRadius(8)
                        }

                        // Favorite
                        HStack {
                            Spacer()

                            let movieObj = Movie(
                                title: movie.title,
                                year: movie.year,
                                imdbID: movie.imdbID,
                                type: "movie",
                                poster: movie.poster
                            )

                            Button {
                                if favoritesManager.isFavorite(movieObj) {
                                    favoritesManager.remove(movieObj)
                                } else {
                                    favoritesManager.add(movieObj)
                                }
                            } label: {
                                Image(systemName: favoritesManager.isFavorite(movieObj) ? "heart.fill" : "heart")
                                    .foregroundColor(.red)
                                    .font(.title2)
                            }
                        }

                        // Movie Info
                        Text(movie.title)
                            .font(.title2)
                            .bold()
                        Text("Year: \(movie.year)")
                        Text("Genre: \(movie.genre)")
                        Text("Plot: \(movie.plot)")
                            .padding(.top, 4)

                        // Director & Cast
                        Text("Director: \(movie.director)")
                        if let actors = movie.actors {
                            Text("Actors: \(actors)")
                        }

                        // Extra info
                        VStack(alignment: .leading, spacing: 4) {
                            if let rating = movie.imdbRating { Text("IMDb Rating: \(rating)") }
                            if let awards = movie.awards, !awards.isEmpty, awards != "N/A" {
                                Text("Awards: \(awards)")
                            }
                        }
                        .padding(.top, 6)

                        // Website
                        if let website = movie.website, website != "N/A" {
                            Link("Official Website", destination: URL(string: website)!)
                                .foregroundColor(.blue)
                                .padding(.top, 6)
                        }
                    }
                    .padding()
                }
            } else {
                Spacer()
                Text("No movie details found.")
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .navigationTitle("Movie Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMovieDetail(imdbID: imdbID)
        }
    }
}

