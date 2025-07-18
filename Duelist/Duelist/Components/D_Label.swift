//
//  D_Label.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct D_Label: View {
    var title: String

    var body: some View {
        Text(title)
            .foregroundStyle(.black)
    }
}

#Preview {
    D_Label(title: "Title")
        .font(.title)
}
