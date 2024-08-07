//
//  ContactAppApp.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct ContactAppApp: App {
    static let store: StoreOf<ContactsFeature> = .init(initialState: ContactsFeature.State()) {
        ContactsFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: Self.store)
        }
    }
}
