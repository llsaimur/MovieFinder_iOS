//
//  MovieSearchView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct MovieSearchView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var query: String = ""
    @FocusState private var isFocused: Bool
    @State private var didAttemptSearch: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)

                        TextField("Search movies", text: $query)
                            .textFieldStyle(.plain)
                            .submitLabel(.search)
                    }
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    Button("Find") {
                        Task { await performSearch() }
                    }
                    .padding(.horizontal, 8)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // Main content
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView("Searching...")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        
                        if !query.isEmpty {
                            Button("Try again") {
                                Task { await performSearch() }
                            }
                            .buttonStyle(.bordered)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if viewModel.movies.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        if !didAttemptSearch {
                            Text("Search for movies by title.")
                                .foregroundColor(.secondary)
                        } else {
                            Text("No results found.")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    MovieListView(viewModel: viewModel)
                }
            }
            .navigationTitle("Search")
            .animation(.default, value: viewModel.isLoading)
        }
    }
    
    private func performSearch() async {
        didAttemptSearch = true
        
        if let cached = CacheManager.shared.getSearchResults(for: query), !cached.isEmpty {
            viewModel.movies = cached
        }
        
        await viewModel.searchMovies(query: query)
    }
}
