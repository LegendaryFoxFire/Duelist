//
//  Gameplay_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI

struct Gameplay_V: View {
    @EnvironmentObject var nav: NavigationHandler

    @StateObject private var viewModel = motion()

    var body: some View {
        VStack(spacing: 20) {
            Image("practice sword")
                .resizable()
                .frame(width: 500, height: 500)
                .rotationEffect(viewModel.swordAngle)
            Text("Currently: ")
                .font(.headline)
            HStack {
                Text("Acceleration: \(String(format: "%.2f", viewModel.deviceMotionData.acceleration))")
                Text("yaw: \(String(format: "%.2f", viewModel.deviceMotionData.yaw))")
                Text("Action: \(String(viewModel.deviceMotionData.action.rawValue))")
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
