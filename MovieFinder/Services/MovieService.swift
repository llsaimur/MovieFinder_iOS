//
//  MovieService.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation

class MovieService: ObservableObject {
    @Published var searchResults: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let apiKey = ProcessInfo.processInfo.environment["OMDB_API_KEY"] ?? ""
    private let baseURL = "https://www.omdbapi.com/"

    private var currentPage = 1
    private var totalResults = 0
    private var currentQuery = ""

    func search(title: String) async {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.searchResults = []
            self.errorMessage = nil
            return
        }

        if trimmed != currentQuery {
            currentQuery = trimmed
            currentPage = 1
            totalResults = 0
            searchResults = []
        }

        if let cached = CacheManager.shared.getSearchResults(for: trimmed),
           !cached.isEmpty,
           currentPage == 1 {
            self.searchResults = cached
        }

        isLoading = true
        errorMessage = nil

        guard let query = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?apikey=\(apiKey)&s=\(query)&type=movie&page=\(currentPage)") else {
            self.errorMessage = "Invalid search URL"
            self.isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let result = try JSONDecoder().decode(SearchResponse.self, from: data)

            if result.Response == "True", let movies = result.Search {
                let newMovies = movies.filter { !self.searchResults.contains($0) }
                self.searchResults += newMovies
                totalResults = Int(result.totalResults ?? "\(movies.count)") ?? movies.count

                CacheManager.shared.appendSearchResults(newMovies, for: trimmed)

                currentPage += 1
            } else {
                if currentPage == 1 { self.searchResults = [] }
                self.errorMessage = result.Error ?? "No results"
            }

        } catch {
            self.searchResults = []
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }


    func fetchMovieDetail(imdbID: String) async -> MovieDetail? {
        if let cached = CacheManager.shared.getMovieDetail(for: imdbID) {
            return cached
        }

        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&i=\(imdbID)&plot=full") else {
            print("Invalid detail URL")
            return nil
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let detail = try JSONDecoder().decode(MovieDetail.self, from: data)

            CacheManager.shared.saveMovieDetail(detail, for: imdbID)
            return detail

        } catch {
            print("Error fetching movie detail:", error.localizedDescription)
            return nil
        }
    }
}
