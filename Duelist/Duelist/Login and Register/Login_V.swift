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
                
                VStack(alignment: .leading) {
                    D_TextField(text: $email, type: .normal, keyword: "Email")
                    
                    D_TextField(text: $password, type: .secure, keyword: "Password")
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
