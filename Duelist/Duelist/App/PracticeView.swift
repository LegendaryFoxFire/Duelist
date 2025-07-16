//
//  ContentView.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI

struct PracticeView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .font(.title)
                .fontWeight(.ultraLight)
            
            D_Card (width: 200, height: 150){
                D_Button(action: { count += 1 }) {
                    Text("+1")
                }
                D_Button(action: { count = 0 }) {
                    Text("Reset")
                }
                D_Button(action: { count -= 1 }) {
                    Text("-1")
                }
            }
        }
        .padding()
    }
}

#Preview {
    PracticeView()
}
