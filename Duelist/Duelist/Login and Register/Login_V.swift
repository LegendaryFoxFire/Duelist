//
//  Login_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//


import SwiftUI

struct Login: View {
    @StateObject private var authManager = AuthManager()
    @EnvironmentObject var nav: NavigationHandler
     
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(email: String = "", password: String = "") {
        _email = State(initialValue: email)
        _password = State(initialValue: password)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                D_Label(title: "Login")
                    .font(.largeTitle)
                
                VStack() {
                    D_TextField(text: $email, type: .normal, keyword: "Email")

                    D_TextField(text: $password, type: .secure, keyword: "Password")
                }
                
                D_Button(action: {
                    Task {
                        do {
                            try await authManager.signIn(email: email, password: password)
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                }) {
                    Text("Login")
                }
                NavigationLink("Register", destination: Register(email: email, password: password))
                
                Image("swords")
                    .resizable()
                    .scaledToFit()
            }
            .alert("Error", isPresented: $showError) {
                        Button("OK") { }
                    } message: {
                        Text(errorMessage)
                    }
            .padding()
        }
    }
}

#Preview {
    Login()
}
