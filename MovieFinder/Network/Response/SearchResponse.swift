//
//  SearchResponse.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//

import Foundation

struct SearchResponse: Codable {
    let Search: [Movie]?
    let totalResults: String?
    let Response: String
    let Error: String?
}
