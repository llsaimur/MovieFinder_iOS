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

    func search(title: String) async {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            self.searchResults = []
            self.errorMessage = nil
            return
        }

        isLoading = true
        errorMessage = nil

        guard let query = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            self.errorMessage = "Invalid search term"
            self.isLoading = false
            return
        }

        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&s=\(query)&type=movie") else {
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

            if result.Response == "True" {
                self.searchResults = result.Search ?? []
            } else {
                self.searchResults = []
                self.errorMessage = result.Error ?? "No results"
            }

        } catch {
            self.searchResults = []
            self.errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
