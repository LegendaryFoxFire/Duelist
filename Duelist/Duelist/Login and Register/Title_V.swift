//
//  Title_V.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct Title_Screen: View {
    @State private var navigateToLogin = false

    var body: some View {
        NavigationStack {
            VStack {
                Image("swords")
                D_Label(title: "Duelist")
                    .font(.system(size: 80))
                    .bold(true)
                D_Label(title: "Tap Screen to Continue")
                    .font(.caption)
            }
            .onTapGesture {
                navigateToLogin = true
            }
            .navigationDestination(isPresented: $navigateToLogin){
                Login()
            }
        }
    }
}
