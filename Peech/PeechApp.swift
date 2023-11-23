//
//  PeechApp.swift
//  Peech
//
//  Created by Yuliia on 14/11/23.
//

import SwiftUI
import SwiftData


@main
struct PeechApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.modelContainer(for: ConvertedFile.self)
    }
}
