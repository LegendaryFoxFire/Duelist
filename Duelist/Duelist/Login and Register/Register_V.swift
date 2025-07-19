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
                
                VStack(alignment: .leading, spacing: 20) {
                    TextField("Email", text: $email)   //textfield expects a binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $password) //securefield also expects a binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Re-Enter Password", text: $reEnterPassword) //securefield also expects a binding
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                D_Button(action: {
                    // FIXME: implement Register database logic
                    print("Register not implemented")
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
