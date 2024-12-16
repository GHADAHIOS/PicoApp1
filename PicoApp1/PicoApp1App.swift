//
//  PicoApp1App.swift
//  PicoApp1
//
//  Created by GHADAH ALENEZI on 14/06/1446 AH.
//

import SwiftUI
import SwiftData

@main
struct PicoApp1App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            CategoriesScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
