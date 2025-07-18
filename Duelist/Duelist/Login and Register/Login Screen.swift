//
//  Login Screen.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Login: View {
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
                    print("Login not implemented")
                }) {
                    Text("Login")
                }
                
                NavigationLink(destination: Register()){
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
    Login()
}

