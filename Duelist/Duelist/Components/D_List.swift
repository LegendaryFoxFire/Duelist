//
//  D_List.swift
//  Duelist
//
//  Created by Sam on 25/07/25.
//

import SwiftUI

struct D_List<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        List {
            content
        }
        .listStyle(.plain) // or whatever style you prefer
        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        //.scrollContentBackground(.hidden) // iOS 16+
        .background(Color.black.opacity(0.25))
    }
}

struct D_ListRow<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .listRowSeparator(.hidden)
    }
}
