//
//  D_Background.swift
//  Duelist
//
//  Created by Sam on 26/07/25.
//

import SwiftUI

struct D_Background<Content: View>: View {
    @EnvironmentObject var nav: NavigationHandler
    let content: () -> Content

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("background_0")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea() // ensures it fills under notch/safe
                content()
                    .frame(width: geo.size.width, height: geo.size.height)
            }

        }
        .ignoresSafeArea()
    }
}

#Preview {
    D_Background{
        PracticeView()
    }

}
