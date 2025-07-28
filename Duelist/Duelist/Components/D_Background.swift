//
//  D_Background.swift
//  Duelist
//
//  Created by Sam on 26/07/25.
//

import SwiftUI

struct D_Background<Content: View>: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    let content: () -> Content

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(getBackgroundImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()
                
                content()
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .ignoresSafeArea()
    }
    
    private func getBackgroundImage() -> String {
        guard let user = authManager.user else {
            return ThemeConstants.getBackgroundImage(for: "Default")
        }
        return ThemeConstants.getBackgroundImage(for: user.theme)
    }
}

#Preview {
    D_Background {
        PracticeView()
    }
}
