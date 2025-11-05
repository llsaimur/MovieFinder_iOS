//
//  MovieDetailViewModel.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/5/25.
//

import Foundation

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieService()) {
        self.movieService = movieService
    }
    
    func fetchMovieDetail(imdbID: String) async {
        isLoading = true
        errorMessage = nil
        movieDetail = nil
        
        guard let detail = await movieService.fetchMovieDetail(imdbID: imdbID) else {
            self.errorMessage = "Failed to load movie details."
            self.isLoading = false
            return
        }
        
        self.movieDetail = detail
        self.isLoading = false
    }
}
