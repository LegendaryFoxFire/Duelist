//
//  Register_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var nav: NavigationHandler
    @StateObject private var authManager = AuthManager()
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    init(email: String = "", password: String = "") {
        _email = State(initialValue: email)
        _password = State(initialValue: password)
    }

    var body: some View {
        BackButton(label:"Login", destination: .login(email: email, password: password)) {
            VStack(spacing: 30) {
                D_Label(title: "Register")
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    D_TextField(text: $email, type: .normal, keyword: "Email")
                    D_TextField(text: $password, type: .secure, keyword: "Password")
                    D_TextField(text: $reEnterPassword, type: .secure, keyword: "Re-Enter Password")
                }
                
                D_Button(action: {
                    Task {
                        do {
                            try await authManager.signUp(email: email, password: password)
                            NavigationHandler.animatePageChange {
                                nav.currentPage = .mainMenu
                            }
                        } catch {
                            errorMessage = error.localizedDescription
                            showError = true
                        }
                    }
                }) {
                    Text("Register")
                }
                
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
    Register(email: "test@example.com", password: "123456")
}
