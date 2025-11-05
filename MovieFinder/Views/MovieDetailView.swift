//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//

import SwiftUI

struct MovieDetailView: View {
    @StateObject private var viewModel = MovieDetailViewModel()
    let imdbID: String

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                VStack {
                    Spacer()
                    ProgressView("Loading details...")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Spacer()
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        Task { await viewModel.fetchMovieDetail(imdbID: imdbID) }
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding()
                
            } else if let movie = viewModel.movieDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // Poster
                        AsyncImage(url: URL(string: movie.poster)) { image in
                            image.resizable()
                                 .scaledToFit()
                                 .cornerRadius(12)
                                 .shadow(radius: 3)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                                .cornerRadius(12)
                        }

                        // Info
                        VStack(alignment: .leading, spacing: 6) {
                            Text(movie.title)
                                .font(.title)
                                .bold()
                            Text("Year: \(movie.year)")
                                .foregroundColor(.secondary)
                            if let rated = movie.rated { Text("Rated: \(rated)") }
                            if let released = movie.released { Text("Released: \(released)") }
                            if let runtime = movie.runtime { Text("Runtime: \(runtime)") }
                            Text("Genre: \(movie.genre)")
                        }
                        
                        Divider()

                        // Cast
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Director: \(movie.director)")
                            if let writer = movie.writer { Text("Writer: \(writer)") }
                            if let actors = movie.actors { Text("Actors: \(actors)") }
                        }

                        Divider()

                        // Plot
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Plot")
                                .font(.headline)
                            Text(movie.plot)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Divider()

                        // Additional info
                        VStack(alignment: .leading, spacing: 6) {
                            if let language = movie.language { Text("Language: \(language)") }
                            if let country = movie.country { Text("Country: \(country)") }
                            if let awards = movie.awards, !awards.isEmpty, awards != "N/A" {
                                Text("Awards: \(awards)")
                            }
                            if let metascore = movie.metascore, metascore != "N/A" {
                                Text("Metascore: \(metascore)")
                            }
                            if let imdbRating = movie.imdbRating { Text("IMDb Rating: \(imdbRating)") }
                            if let imdbVotes = movie.imdbVotes { Text("IMDb Votes: \(imdbVotes)") }
                            if let boxOffice = movie.boxOffice, boxOffice != "N/A" {
                                Text("Box Office: \(boxOffice)")
                            }
                            if let production = movie.production, production != "N/A" {
                                Text("Production: \(production)")
                            }
                            if let dvd = movie.dvd, dvd != "N/A" {
                                Text("DVD Release: \(dvd)")
                            }
                        }

                        // Ratings
                        if let ratings = movie.ratings, !ratings.isEmpty {
                            Divider()
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ratings")
                                    .font(.headline)
                                ForEach(ratings, id: \.source) { rating in
                                    Text("\(rating.source): \(rating.value)")
                                }
                            }
                        }

                        // Website
                        if let website = movie.website, website != "N/A" {
                            Divider()
                            Link("Visit Official Website", destination: URL(string: website)!)
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else {
                VStack {
                    Spacer()
                    Text("No details available.")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMovieDetail(imdbID: imdbID)
        }
    }
}
