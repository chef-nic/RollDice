//
//  RollDiceApp.swift
//  RollDice
//
//  Created by Nicholas Johnson on 8/6/24.
//

import SwiftUI
import SwiftData

@main
struct RollDiceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Roll.self)
    }
}
