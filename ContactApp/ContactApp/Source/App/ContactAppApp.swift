//
//  ContactAppApp.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI

@main
struct ContactAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContactsView(
                store: .init(
                    initialState: ContactsFeature.State()
                ) {
                    ContactsFeature()
                }
            )
        }
    }
}
