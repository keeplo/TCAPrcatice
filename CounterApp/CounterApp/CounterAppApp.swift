//
//  CounterAppApp.swift
//  CounterApp
//
//  Created by 김용우 on 8/6/24.
//

import ComposableArchitecture
import SwiftUI

@main
struct CounterAppApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: Self.store)
        }
    }
}
