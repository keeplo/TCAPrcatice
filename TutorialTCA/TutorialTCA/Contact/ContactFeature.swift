//
//  ContactFeature.swift
//  TutorialTCA
//
//  Created by 김용우 on 2023/11/28.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

struct ContactsFeature: Reducer {
    
    struct State: Equatable {
        @PresentationState var addContact: AddContactFeature.State?
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
                    state.addContact = nil
                    return .none
                    
                case .addContact:
                    return .none
            }
        }
        .ifLet(\.$addContact, action: /Action.addContact) {
            AddContactFeature()
        }
    }
}
