//
//  AddContactView.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(
            store: .init(
                initialState: AddContactFeature.State(
                    contact: .init(id: .init(), name: "Blob")
                )
            ) {
                AddContactFeature()
            }
        )
    }
}
