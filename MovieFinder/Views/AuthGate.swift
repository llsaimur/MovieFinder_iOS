//
//  AuthGate.swift
//  MovieFinder
//
//  Created by Saimur Rashid on 11/2/25.
//


import SwiftUI

struct AuthGate: View {
    @State private var showLogin = true

    var body: some View {
        VStack(spacing: 20) {
            Picker("", selection: $showLogin) {
                Text("Login").tag(true)
                Text("Sign Up").tag(false)
            }
            .pickerStyle(.segmented)
            .padding()

            if showLogin {
                LoginView()
            }
            else {
                RegisterView()
            }
        }
    }
}

#Preview {
    AuthGate()
}
