//
//  TutorialTCAApp.swift
//  TutorialTCA
//
//  Created by 김용우 on 2023/08/04.
//

import ComposableArchitecture

import SwiftUI

@main
struct TutorialTCAApp: App {
    
    static let store = Store(
        initialState: CounterFeature.State(),
        reducer: {
            CounterFeature()
                ._printChanges()
        }
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: Self.store)
        }
    }
}
