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
        @PresentationState var destination: Destination.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case deleteButtonTapped(id: Contact.ID)
        case destination(PresentationAction<Destination.Action>)
        
        enum Alert: Equatable {
            case confirmDeletion(id: Contact.ID)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .addButtonTapped:
                    state.destination = .addContact(
                        AddContactFeature.State(
                            contact: .init(id: .init(), name: "")
                        )
                    )
                    return .none
                    
                case .destination(.presented(.addContact(.delegate(.saveContact(let contact))))):
                    state.contacts.append(contact)
                    return .none
                    
                case .destination(.presented(.alert(.confirmDeletion(id: let id)))):
                    state.contacts.remove(id: id)
                    return .none
                    
                case .destination:
                    return .none
                    
                case .deleteButtonTapped(let id):
                    state.destination = .alert(
                        AlertState(
                            title: { TextState("Are you sure?") },
                            actions: {
                                ButtonState(
                                    role: .destructive,
                                    action: Action.Alert.confirmDeletion(id: id),
                                    label: { TextState("Delete") }
                                )
                            }
                        )
                    )
                    return .none
            }
        }
        .ifLet(\.$destination, action: /Action.destination) {
            Destination()
        }
    }
}

extension ContactsFeature {
    
    struct Destination: Reducer {
        
        enum State: Equatable {
            case addContact(AddContactFeature.State)
            case alert(AlertState<ContactsFeature.Action.Alert>)
        }
        
        enum Action {
            case addContact(AddContactFeature.Action)
            case alert(ContactsFeature.Action.Alert)
        }
        
        var body: some ReducerOf<Self> {
            Scope(state: /State.addContact , action: /Action.addContact) {
                AddContactFeature()
            }
        }
    }
    
}
