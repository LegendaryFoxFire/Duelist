    //
    //  Login_V.swift
    //  Duelist
    //
    //  Created by Sam on 18/07/25.
    //
    import SwiftUI

    struct Login: View {
        @EnvironmentObject var authManager: AuthManager
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
            D_Background {
                VStack() {
                    D_Label(title: "Login", fontSize: Globals.LargeTitleFontSize)
                        .font(.largeTitle)
                    
                    VStack() {
                        D_TextField(text: $email, type: .normal, keyword: "Email")
                        
                        D_TextField(text: $password, type: .secure, keyword: "Password")
                    }
                    
                    D_Button(action: {
                        Task {
                            do {
                                try await authManager.signIn(email: email, password: password)
                                NavigationHandler.animatePageChange {
                                    nav.currentPage = .mainMenu
                                }
                            } catch {
                                errorMessage = error.localizedDescription
                                showError = true
                            }
                        }
                    }) {
                        Text("Login")
                    }
                    Button("Register"){
                        NavigationHandler.animatePageChange {
                            nav.currentPage = .register(email: email, password: password)
                        }
                    }
                    .padding()
                    Image("transparentbgswords")
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 10)
                        .background(Color.clear)
                        .padding()
                        .opacity(0.95)
                }

                .padding()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
        
    }

    #Preview {
        Login()
    }
