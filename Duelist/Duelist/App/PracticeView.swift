//
//  ContentView.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//
//  toy view to play with SUI

import SwiftUI

struct PracticeView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 50) {
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
                D_Button(action: {count *= 2}){
                    Text("*2")
                }
            }
        }
        .padding()
    }
}

#Preview {
    PracticeView()
}
