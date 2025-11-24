//
//  ProfileView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct ProfileView: View {
    @ObservedObject private var auth = AuthService.shared
    @State private var newName = ""
    @State private var errorText: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            )

                        Text(auth.currentUser?.displayName ?? "-")
                            .font(.title2).bold()

                        Text(auth.currentUser?.email ?? "-")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(auth.currentUser?.isActive == true ? "Active Account" : "Inactive")
                            .font(.footnote)
                            .foregroundColor(auth.currentUser?.isActive == true ? .green : .red)
                            .padding(.top, 4)
                    }
                    .padding(.top, 30)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Update Display Name")
                            .font(.headline)
                        
                        TextField("New Display Name", text: $newName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            )

                        if let errorText {
                            Text(errorText)
                                .foregroundColor(.red)
                                .font(.footnote)
                        }

                        Button(action: saveName) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Button(role: .destructive) {
                        let result = auth.signOut()
                        if case .failure(let err) = result { errorText = err.localizedDescription }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward.square")
                                .font(.title2)
                                .foregroundColor(.red)
                            Text("Sign Out")
                                .bold()
                                .foregroundColor(.red)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
            .navigationTitle("Profile")
            .onAppear { auth.fetchCurrentAppUser { _ in } }
        }
    }

    private func saveName() {
        guard !newName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorText = "Cannot be empty"
            return
        }
        auth.updateProfile(displayName: newName) { result in
            switch result {
            case .success:
                newName = ""
                errorText = nil
            case .failure(let err):
                errorText = err.localizedDescription
            }
        }
    }
}

#Preview {
    ProfileView()
}
