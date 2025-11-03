//
//  SearchView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//

import SwiftUI

struct MovieSearchView: View {
    @EnvironmentObject var omdb: OMDbService
    @State private var query: String = ""
    @FocusState private var isFocused: Bool
    @State private var didAttemptSearch: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 8) {
                    TextField("Search movies", text: $query, onCommit: {
                        Task { await performSearch() }
                    })
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)
                    .submitLabel(.search)

                    Button("Search") {
                        Task { await performSearch() }
                        isFocused = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                // Main content
                if omdb.isLoading {
                    // Loading view
                    VStack {
                        Spacer()
                        ProgressView("Searching...")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let error = omdb.errorMessage {
                    // Error view
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

                } else if omdb.searchResults.isEmpty {
                    // Placeholder / empty results
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
                    // Results list
                    MovieListView(movies: omdb.searchResults)
                }
            }
            .navigationTitle("Search")
            .animation(.default, value: omdb.isLoading)
        }
    }

    private func performSearch() async {
        didAttemptSearch = true
        await omdb.search(title: query)
    }
}
