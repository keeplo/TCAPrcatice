//
//  ContactsFeature.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import Foundation
import ComposableArchitecture

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    state.addContact = AddContactFeature.State(
                        contact: .init(id: .init(), name: "")
                    )
                    return .none
                    
                case .addContact(.presented(.delegate(.saveContact(let contact)))):
                    state.contacts.append(contact)
                    return .none
                    
                case .addContact:
                    return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
    
}
