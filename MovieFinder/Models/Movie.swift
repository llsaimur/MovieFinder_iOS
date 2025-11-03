//
//  Movie.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation

struct Movie: Codable, Identifiable {
    var id: String { imdbID }

    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}