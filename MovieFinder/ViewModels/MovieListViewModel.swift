//
//  MovieListViewModel.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation

class MovieListViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let movieService: MovieService
    
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
        
        isLoading = true
        errorMessage = nil
        
        await movieService.search(title: trimmed)

        movies = movieService.searchResults
        errorMessage = movieService.errorMessage
        isLoading = movieService.isLoading
    }
}
