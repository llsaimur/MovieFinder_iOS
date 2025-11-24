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
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView("Loading movie info…")
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
                    VStack(spacing: 20) {

                        // Poster
                        AsyncImage(url: URL(string: movie.poster)) { img in
                            img.resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(radius: 4)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 260)
                                .cornerRadius(12)
                        }

                        // Title
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(movie.title)
                                    .font(.title2).bold()
                                Text(movie.year)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            let movieObj = Movie(
                                title: movie.title,
                                year: movie.year,
                                imdbID: movie.imdbID,
                                type: "movie",
                                poster: movie.poster
                            )

                            // Add/Remove favorites
                            Button {
                                if favoritesManager.isFavorite(movieObj) {
                                    favoritesManager.remove(movieObj)
                                    alertMessage = "Removed \"\(movie.title)\" from your favorites."
                                } else {
                                    favoritesManager.add(movieObj)
                                    alertMessage = "Added \"\(movie.title)\" to your favorites!"
                                }
                                showAlert = true
                            } label: {
                                Image(systemName: favoritesManager.isFavorite(movieObj) ? "heart.fill" : "heart")
                                    .font(.title2)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Movie details
                        VStack(alignment: .leading){
                            
                            SectionCard(title: "Plot", text: movie.plot, icon: "doc.text")
                            
                            if let actors = movie.actors {
                                SectionCard(title: "Cast", text: actors, icon: "person.3")
                            }
                            
                            SectionCard(title: "Director", text: movie.director, icon: "person.crop.rectangle")
                            SectionCard(title: "Genre", text: movie.genre, icon: "tag")

                            if let rating = movie.imdbRating {
                                SectionCard(title: "IMDb Rating", text: rating, icon: "star.fill")
                            }

                            if let awards = movie.awards, awards != "N/A" {
                                SectionCard(title: "Awards", text: awards, icon: "rosette")
                            }

                            if let website = movie.website, website != "N/A" {
                                Link("Official Website", destination: URL(string: website)!)
                                    .font(.headline)
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom)
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
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Favorites"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        .task {
            await viewModel.fetchMovieDetail(imdbID: imdbID)
        }
    }
}





