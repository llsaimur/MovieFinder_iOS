//
//  AppUser.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation
import FirebaseFirestore

struct AppUser: Identifiable, Codable {
    @DocumentID var id: String? // FirebaseAuth.User.uid
    let email: String
    var displayName: String
    var isActive: Bool = true
}
