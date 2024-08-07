//
//  ContactsView.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
    
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
                        action : {
                            store.send(.addButtonTapped)
                        }, label: {
                            Image(systemName: "plus")
                        }
                    )
                }
            }
        }
        .sheet(
            item: $store.scope(state: \.addContact, action: \.addContact)
        ) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
    }
    
}

#Preview {
    ContactsView(
        store: .init(
            initialState: ContactsFeature.State()
        ) {
            ContactsFeature()
        }
    )
}
