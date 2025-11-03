//
//  AuthService.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {

    static let shared = AuthService()
    
    @Published var currentUser: AppUser?
    
    private let db = Firestore.firestore()
    
    // sign up
    func signUp(email: String, password: String, displayName: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let user = result?.user else {
                return completion(.failure(SimpleError("No user found")))
            }
            
            let appUser = AppUser(id: user.uid, email: email, displayName: displayName)
            
            do {
                try self.db.collection("users").document(user.uid).setData(from: appUser) { err in
                    if let err = err {
                        return completion(.failure(err))
                    }
                    DispatchQueue.main.async { self.currentUser = appUser }
                    completion(.success(appUser))
                }
            } catch {
                completion(.failure(SimpleError("Unable to create Profile")))
            }
        }
    }
    
    // login
    func login(email: String, password: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let user = result?.user else {
                return completion(.failure(SimpleError("No user found")))
            }
            
            // fetch current user
            self.fetchCurrentAppUser { res in
                switch res {
                case .failure(let err):
                    completion(.failure(err))
                case .success(let appUserObj):
                    if let appUser = appUserObj {
                        completion(.success(appUser))
                    } else {
                        // minimal user object
                        let email = user.email ?? "No Email"
                        let name = user.displayName ?? "No Name"
                        let appUser = AppUser(id: user.uid, email: email, displayName: name)
                        
                        do {
                            try self.db.collection("users").document(user.uid).setData(from: appUser) { err in
                                if let err = err {
                                    return completion(.failure(err))
                                }
                                DispatchQueue.main.async {
                                    self.currentUser = appUser
                                }
                                completion(.success(appUser))
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    // get user
    func fetchCurrentAppUser(completion: @escaping (Result<AppUser?, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async { self.currentUser = nil }
            return completion(.success(nil))
        }
        
        db.collection("users").document(uid).getDocument { snap, error in
            if let error = error {
                return completion(.failure(error))
            }
            guard let snap = snap else {
                return completion(.success(nil))
            }
            
            do {
                let user = try snap.data(as: AppUser.self)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // update user
    func updateProfile(displayName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return completion(.success(()))
        }
        
        db.collection("users").document(uid).updateData(["displayName": displayName]) { error in
            if let error = error {
                return completion(.failure(error))
            }
            self.fetchCurrentAppUser { _ in completion(.success(())) }
        }
    }
    
    //sign out
    func signOut() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.currentUser = nil
            }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
