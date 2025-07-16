//
//  D_Button.swift
//  Duelist
//
//  Created by John Bukoski on 7/16/25.
//

import SwiftUI

struct D_Button<Label: View>: View {
    @GestureState private var isPressed: Bool = false
    var action: () -> Void
    var label: () -> Label
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image("backdrop_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: Globals.StandardHeight)
                    .clipped()
                    .cornerRadius(Globals.CornerRadius)
                label()
                    .foregroundStyle(.white)
                    .padding(.horizontal, Globals.SmallHPadding)
                    .padding(.vertical, Globals.SmallVPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Globals.CornerRadius)
                            .fill(isPressed ? ThemeColors.accent.opacity(0.5) : ThemeColors.primary.opacity(0.2))
                            .padding(.vertical, Globals.SmallVPadding)
                    )
            }
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: Globals.CornerRadius)
                    .stroke(isPressed ? ThemeColors.accent : Color.clear, lineWidth: 2)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, gestureState, _ in
                        gestureState = true
                    }
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

#Preview {
    D_Button(action: {
        print("Button 1 Tapped")
    }) {
        Text("Hello")
    }
}
