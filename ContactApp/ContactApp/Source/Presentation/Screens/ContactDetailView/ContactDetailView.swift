//
//  ContactDetailView.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    @Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            Button(
                action: { store.send(.deleteButtonTapped) },
                label: { Text("Delete") }
            )
        }
        .navigationTitle(Text(store.contact.name))
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    NavigationStack {
        ContactDetailView(
            store: .init(
                initialState: ContactDetailFeature.State(
                    contact: .init(id: .init(), name: "Blob")
                )
            ) {
                ContactDetailFeature()
            }
        )
    }
}
