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
                    .resizable()    //Makes the image scalable — this is necessary before applying resizing modifiers like .frame() or .aspectRatio().
                    .aspectRatio(contentMode: .fill) //Scales the image to fill the container’s dimensions, cropping parts if necessary to maintain its aspect ratio.

                    .frame(height: Globals.StandardHeight) //Sets a fixed height for the image. Width will be determined by the parent container.

                    .clipped()  //Cuts off any part of the image that overflows its frame bounds.

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
            .contentShape(Rectangle())  //Defines the tappable/touchable area of the view
            .overlay(     // This gives a visual feedback effect when pressing the button — a colored outline appears.
                RoundedRectangle(cornerRadius: Globals.CornerRadius)
                    .stroke(isPressed ? ThemeColors.accent : Color.clear, lineWidth: 2)       // If isPressed is true, the stroke is ThemeColors.accent. If not pressed, it’s Color.clear, meaning no visible border.
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
