import Foundation
import SwiftUI

@MainActor
class MovieListViewModel: ObservableObject {
    @Published var movies: [MovieSummary] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let omdbService: OMDbService
    
    init(omdbService: OMDbService = OMDbService()) {
        self.omdbService = omdbService
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
        
        await omdbService.search(title: trimmed)
        
        // Update view model state from service
        movies = omdbService.searchResults
        errorMessage = omdbService.errorMessage
        isLoading = omdbService.isLoading
    }
}
