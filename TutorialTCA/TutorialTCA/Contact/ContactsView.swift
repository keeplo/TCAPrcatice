//
//  ContactsView.swift
//  TutorialTCA
//
//  Created by 김용우 on 2023/11/28.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    let store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: \.contacts) { viewStore in
                List {
                    ForEach(viewStore.state) { contact in
                        HStack {
                            Text(contact.name)
                            Spacer()
                            Button(
                                action: { viewStore.send(.deleteButtonTapped(id: contact.id)) },
                                label: {
                                    Image(systemName: "trash")
                                    .foregroundColor(.red)
                                }
                            )
                        }
                    }
                }
                .navigationTitle("Contacts")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        .sheet(
            store: self.store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /ContactsFeature.Destination.State.addContact,
            action: { .addContact($0) }
        ) { addContactStore in
            NavigationView {
                AddContactView(store: addContactStore)
            }
        }
        .alert(
            store: self.store.scope(
                state: \.$destination,
                action: { .destination($0) }
            ),
            state: /ContactsFeature.Destination.State.alert,
            action: { .alert($0) }
        )
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(store: Store(
            initialState: ContactsFeature.State(),
            reducer: {
                ContactsFeature()
                    ._printChanges()
            }
        ))
    }
}
