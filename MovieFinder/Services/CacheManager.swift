//
//  CacheManager.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/17/25.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private var searchCache: [String: [Movie]] = [:]
    private var detailCache: [String: MovieDetail] = [:]
    
    private init() {}
    
    func getSearchResults(for query: String) -> [Movie]? {
        return searchCache[query]
    }
    
    func appendSearchResults(_ movies: [Movie], for query: String) {
        if let existing = searchCache[query] {
            searchCache[query] = existing + movies
        } else {
            searchCache[query] = movies
        }
    }
    
    func clearSearchCache() {
        searchCache.removeAll()
    }
    
    func getMovieDetail(for imdbID: String) -> MovieDetail? {
        return detailCache[imdbID]
    }
    
    func saveMovieDetail(_ detail: MovieDetail, for imdbID: String) {
        detailCache[imdbID] = detail
    }
    
    func clearDetailCache() {
        detailCache.removeAll()
    }
    
    func clearAllCaches() {
        clearSearchCache()
        clearDetailCache()
    }
}
