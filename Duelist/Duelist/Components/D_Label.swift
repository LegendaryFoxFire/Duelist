//
//  D_Label.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct D_Label: View {
    var title: String
    var fontSize: CGFloat

    var body: some View {
        Text(title)
            .foregroundStyle(.black)
            .font(.custom("Copperplate", size: fontSize))
            .foregroundColor(.yellow)
            .shadow(radius: 3)
    }
}

#Preview {
    D_Label(title: "Title", fontSize: 24)
        .font(.title)
}
