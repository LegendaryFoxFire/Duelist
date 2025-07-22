//
//  D_TextField.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

enum TextFieldType {
    case normal
    case secure
    case search
}

struct D_TextField: View {
    @Binding var text: String
    var type: TextFieldType
    var keyword: String

    var body: some View {
        if type == .normal {
            TextField(
                "",
                text: $text,
                prompt: Text(keyword)
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(Globals.SmallHPadding)
            
        } else if type == .secure {
            SecureField(
                "",
                text: $text,
                prompt: Text(keyword)
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(Globals.SmallHPadding)
            
        } else if type == .search {
            TextField(
                "",
                text: $text,
                prompt: Text("    Search \(keyword)...")
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(Globals.SmallHPadding)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading)
                    Spacer()
                }
            )
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var textFieldContents = ""

        var body: some View {
            D_TextField(text: $textFieldContents, type: .normal, keyword: "Friends List")
        }
    }

    return PreviewWrapper()
}
