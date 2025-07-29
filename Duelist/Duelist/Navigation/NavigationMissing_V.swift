//
//  NavigationMissing.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//
// For when view points to nothing
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

