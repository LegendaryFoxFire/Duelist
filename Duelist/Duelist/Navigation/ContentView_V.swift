//
//  ContentView_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var nav: NavigationHandler

    var body: some View {
        nav.currentPage.view(nav: nav)
    }
}
