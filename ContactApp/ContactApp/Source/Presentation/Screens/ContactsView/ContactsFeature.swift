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
        @Presents var destination: Destination.State?
        var contacts: IdentifiedArrayOf<Contact> = []
        var path = StackState<ContactDetailFeature.State>()
    }
    
    enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        case path(StackAction<ContactDetailFeature.State, ContactDetailFeature.Action>)
        
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    @Dependency(\.uuid) var uuid
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    state.destination = .addContact(
                        AddContactFeature.State(
                            contact: .init(id: uuid(), name: "")
                        )
                    )
                    return .none
                    
                case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                    state.contacts.append(contact)
                    return .none
                
                case .destination(.presented(.alert(.confirmDeletion(let contactId)))):
                    state.contacts.remove(id: contactId)
                    return .none
                    
                case .destination:
                    return .none
                    
                case .deleteButtonTapped(let contactId):
                    state.destination = .alert(.deleteComfirmation(id: contactId))
                    return .none
                    
                case .path(.element(let id, action: .delegate(.confirmDeletion))):
                    guard let detailState = state.path[id: id] else { return .none }
                    state.contacts.remove(id: detailState.contact.id)
                    return .none
                    
                case .path:
                    return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path) {
            ContactDetailFeature()
        }
    }
    
}

extension ContactsFeature {
    
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
    
}
