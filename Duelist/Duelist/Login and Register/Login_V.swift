//
//  Login_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//


import SwiftUI

struct Login: View {
    @EnvironmentObject var nav: NavigationHandler
     
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                D_Label(title: "Login")
                    .font(.largeTitle)
                
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Email", text: $email)   //textfield expects a binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password) //securefield also expects a binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                D_Button(action: {
                    // FIXME: implement login database logic
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .mainMenu
                    }
                }) {
                    Text("Login")
                }
                
//              Subsequent Views pushed onto this nav stack would use
//              the following code segment in their respective views:
                
//              NavigationLink(destination: ThingView(nav: nav)) {
//                  Text("Go to Thing")
//              }
                
                Button("Register") {
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .register
                    }
                }
                
                Image("swords")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
        }
    }
}

#Preview {
    Login()
}
