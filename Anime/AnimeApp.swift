//
//  AnimeApp.swift
//  Anime
//
//  Created by Riley Williams on 1/13/21.
//

import SwiftUI

@main
struct AnimeApp: App {
    var body: some Scene {
        WindowGroup {
			NavigationView {
				SearchView()
			}.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
