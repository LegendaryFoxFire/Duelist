//
//  Register_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Register: View {
    @EnvironmentObject var nav: NavigationHandler
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var reEnterPassword: String = ""

    var body: some View {
        BackButton(label:"Login", destination: .login) {
            VStack(spacing: 30) {
                D_Label(title: "Register")
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    D_TextField(text: $email, type: .normal, keyword: "Email")
                    D_TextField(text: $password, type: .secure, keyword: "Password")
                    D_TextField(text: $reEnterPassword, type: .secure, keyword: "Re-Enter Password")
                }
                
                D_Button(action: {
                    // FIXME: implement Register database logic
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .mainMenu
                    }
                }) {
                    Text("Register")
                }
                
                Image("swords")
                    .resizable()
                    .scaledToFit()
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    Register()
}
