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
        ZStack  {
            Image("background_0")
                .resizable()
                .scaledToFit()
            content()
        }
    }
}

#Preview {
    D_Background{
        PracticeView()
    }

}
