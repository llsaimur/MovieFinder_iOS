//
//  MovieListView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct MovieListView: View {
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink(destination: MovieDetailView(imdbID: movie.imdbID)) {
                    MovieRowView(movie: movie)
                        .onAppear {
                            if movie == viewModel.movies.last {
                                Task { await viewModel.loadNextPage() }
                            }
                        }
                }
            }
            
            if viewModel.isLoading && !viewModel.movies.isEmpty {
                HStack {
                    Spacer()
                    ProgressView("Loading more...")
                        .padding(.vertical, 8)
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            if let cached = CacheManager.shared.getSearchResults(for: viewModel.currentQuery), !cached.isEmpty {
                viewModel.movies = cached
            }
        }
    }
}


