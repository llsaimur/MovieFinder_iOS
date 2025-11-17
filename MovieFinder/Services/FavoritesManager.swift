//
//  FavoritesManager.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/13/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine


class FavoritesManager: ObservableObject {

    static let shared = FavoritesManager()
    @Published var favorites: [Movie] = []
    private let db = Firestore.firestore()

    private var currentUID: String? {
        Auth.auth().currentUser?.uid
    }

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        guard let uid = currentUID else { return }

        let ref = db.collection("users")
            .document(uid)
            .collection("favorites")

        ref.addSnapshotListener { snapshot, err in
            if let err = err {
                print("Could not load favorites:", err)
                return
            }

            var tempList: [Movie] = []
            snapshot?.documents.forEach { doc in
                if let movie = try? doc.data(as: Movie.self) {
                    tempList.append(movie)
                }
            }

            self.favorites = tempList
        }
    }

    func add(_ movie: Movie) {
        guard let uid = currentUID else { return }

        let ref = db.collection("users")
            .document(uid)
            .collection("favorites")
            .document(movie.imdbID)

        do {
            try ref.setData(from: movie)
        } catch {
            print("Error saving movie:", error)
        }
    }

    func remove(_ movie: Movie) {
        guard let uid = currentUID else { return }

        db.collection("users")
            .document(uid)
            .collection("favorites")
            .document(movie.imdbID)
            .delete { error in
                if let error = error {
                    print("Error removing movie:", error)
                }
            }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        return favorites.first(where: { $0.imdbID == movie.imdbID }) != nil
    }
}
