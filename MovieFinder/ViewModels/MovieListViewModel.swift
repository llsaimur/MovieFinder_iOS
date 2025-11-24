//
//  MovieListViewModel.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let movieService: MovieService
    var currentQuery: String = ""
    private var isAllLoaded = false
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
    
    func searchMovies(query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            movies = []
            errorMessage = nil
            return
        }
        
        currentQuery = trimmed
        isAllLoaded = false
        isLoading = true
        errorMessage = nil
        
        await movieService.search(title: trimmed)
        
        movies = movieService.searchResults
        errorMessage = movieService.errorMessage
        isLoading = movieService.isLoading
    }
    
    func loadNextPage() async {
        guard !isLoading, !isAllLoaded else { return }
        
        let previousCount = movies.count
        await movieService.search(title: currentQuery)
        let newCount = movieService.searchResults.count
        
        movies = movieService.searchResults
        
        if newCount == previousCount {
            isAllLoaded = true
        }
    }
}
