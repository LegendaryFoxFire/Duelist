//
//  BackNavigation.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//

import SwiftUI

struct BackButton<Content: View>: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var label: String
    var destination: NavigationPage
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading) {
            Button("← " + label) {
                NavigationHandler.animatePageChange {
                    nav.currentPage = destination
                }
            }
            .padding(.horizontal, 20)
            .buttonStyle(.borderless)

            content()
        }
    }
}

#Preview {
    BackButton(label: "Back", destination: .title) {
        Rectangle()
            .fill(Color.red)
    }
}
