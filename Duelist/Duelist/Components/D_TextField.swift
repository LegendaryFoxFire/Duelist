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
    @EnvironmentObject var authManager: AuthManager
    @Binding var text: String
    var type: TextFieldType
    var keyword: String

    var body: some View {
        if type == .normal {
            TextField(
                "",
                text: $text,
                prompt: Text(keyword)
                    .foregroundColor(ThemeColors.dynamicSecondary(authManager: authManager))
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(ThemeColors.dynamicTextFieldText(authManager: authManager))  // Black text in all modes
            .padding(Globals.SmallHPadding)
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
            
        } else if type == .secure {
            SecureField(
                "",
                text: $text,
                prompt: Text(keyword)
                    .foregroundColor(ThemeColors.dynamicSecondary(authManager: authManager))
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(ThemeColors.dynamicTextFieldText(authManager: authManager))  // Black text in all modes
            .padding(Globals.SmallHPadding)
            
        } else if type == .search {
            TextField(
                "",
                text: $text,
                prompt: Text("Search \(keyword)...")
                    .foregroundColor(ThemeColors.dynamicSecondary(authManager: authManager))
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(ThemeColors.dynamicTextFieldText(authManager: authManager))  // Black text in all modes
            .padding(.leading, 40)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(ThemeColors.dynamicSecondary(authManager: authManager))
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
            D_TextField(text: $textFieldContents, type: .search, keyword: "Friends List")
        }
    }

    return PreviewWrapper()
}
