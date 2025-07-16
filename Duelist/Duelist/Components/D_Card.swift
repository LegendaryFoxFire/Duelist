//
//  D_Card.swift
//  Duelist
//
//  Created by John Bukoski on 7/16/25.
//
import SwiftUI

struct D_Card<Content: View>: View {
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Globals.CornerRadius)
                .fill(ThemeColors.secondary.opacity(0.5))
                .shadow(radius: Globals.CornerRadius)
            VStack(alignment: .leading, spacing: Globals.SmallHPadding) {
                content()
            }
            .padding()
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    D_Card(width: 200, height: 180) {
        D_Button(action: { print("Tapped One") }) { Text("One") }
        D_Button(action: { print("Tapped Two") }) { Text("Two") }
        D_Button(action: { print("Tapped Three") }) { Text("Three") }
    }
}
