//
//  ContentView.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button(
                        action: { store.send(.addButtonTapped) },
                        label: { Image(systemName: "plus") }
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView(
        store: .init(
            initialState: ContactsFeature.State(
                contacts: [
                    Contact(id: .init(), name: "Blob"),
                    Contact(id: .init(), name: "Blob Jr"),
                    Contact(id: .init(), name: "Blob Sr")
                ]
            )
        ) {
            ContactsFeature()
        }
    )
}
