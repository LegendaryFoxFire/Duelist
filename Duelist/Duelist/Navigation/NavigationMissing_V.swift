//
//  NavigationMissing.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//
import SwiftUI
struct NavMissing: View {
    @EnvironmentObject var nav: NavigationHandler
    
    var body: some View {
        VStack {
            Text("Navigation Missing")
        }
    }
}

#Preview {
    NavMissing()
}

