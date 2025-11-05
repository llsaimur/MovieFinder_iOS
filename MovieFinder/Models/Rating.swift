//
//  Rating.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/5/25.
//


import Foundation

struct Rating: Codable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
