//
//  RegisterView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var errorMessage: String?

    @StateObject private var auth = AuthService.shared

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image("MovieFinderIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                
                Text("Movie Finder")
                    .font(.largeTitle)
                    .bold()
                
                Text("Discover your favorite movies!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 40)

            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .textInputAutocapitalization(.never)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                TextField("Display Name", text: $displayName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }

            Button(action: signUp) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(email.isEmpty || password.isEmpty || displayName.isEmpty)

            Spacer()
        }
        .padding(.top)
    }

    private func signUp() {
        guard Validators.isValidEmail(email) else {
            errorMessage = "Invalid Email"
            return
        }
        guard Validators.isValidPassword(password) else {
            errorMessage = "Invalid Password"
            return
        }
        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Display Name required"
            return
        }

        auth.signUp(email: email, password: password, displayName: displayName) { result in
            switch result {
            case .success: errorMessage = nil
            case .failure(let err): errorMessage = err.localizedDescription
            }
        }
    }
}

#Preview {
    RegisterView()
}

