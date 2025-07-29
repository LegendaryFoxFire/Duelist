//
//  Register_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager

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
        D_Background {
            BackButton(label:"Login", destination: .login(email: email, password: password)) {
                VStack(spacing: 30) {
                    D_Label(title: "Register", fontSize: Globals.LargeTitleFontSize)
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading) {
                        D_TextField(text: $email, type: .normal, keyword: "Email")
                        D_TextField(text: $password, type: .secure, keyword: "Password")
                        D_TextField(text: $reEnterPassword, type: .secure, keyword: "Re-Enter Password")
                    }
                    
                    D_Button(action: {
                        // Validate email format
                        guard isValidEmail(email) else {
                            errorMessage = "Please enter a valid email address"
                            showError = true
                            return
                        }
                        
                        // Validate password length
                        guard password.count >= 6 else {
                            errorMessage = "Password must be at least 6 characters long"
                            showError = true
                            return
                        }
                        
                        // Validate passwords match
                        guard password == reEnterPassword else {
                            errorMessage = "Passwords don't match"
                            showError = true
                            return
                        }
                        
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
                    
                    Image("transparentbgswords")
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
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    Register(email: "test@example.com", password: "123456")
}
