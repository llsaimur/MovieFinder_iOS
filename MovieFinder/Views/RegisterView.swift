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
        Form {
            Section("Create Account") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
                TextField("Display Name", text: $displayName)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }

            Button("Sign Up") {
                guard Validators.isValidEmail(email) else {
                    errorMessage = "Invalid Email";
                    return
                }
                
                guard Validators.isValidPassword(password) else {
                    errorMessage = "Invalid Password";
                    return
                }
                guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
                    errorMessage = "Display Name required";
                    return
                }

                auth.signUp(email: email, password: password, displayName: displayName) { result in
                    switch result {
                    case .success: errorMessage = nil
                    case .failure(let err):
                        errorMessage = err.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty || displayName.isEmpty)
        }
    }
}

#Preview {
    RegisterView()
}
