//
//  LoginView.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    
    @StateObject private var auth = AuthService.shared

    var body: some View {
        Form {
            Section("Login") {
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }

            Button("Login") {
                guard Validators.isValidEmail(email) else {
                    errorMessage = "Invalid Email";
                    return
                }
                guard Validators.isValidPassword(password) else {
                    errorMessage = "Invalid Password";
                    return
                }

                auth.login(email: email, password: password) { result in
                    switch result {
                    case .success: errorMessage = nil
                    case .failure(let err):
                        errorMessage = err.localizedDescription
                    }
                }
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
}

#Preview {
    LoginView()
}
