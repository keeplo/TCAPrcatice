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
                
                case .destination(.presented(.alert(.confirmDeletion(let contactId)))):
                    state.contacts.remove(id: contactId)
                    return .none
                    
                case .destination:
                    return .none
                    
                case .deleteButtonTapped(let contactId):
                    state.destination = .alert(
                        .init(
                            title: { TextState("Are your sure?") },
                            actions: {
                                ButtonState(
                                    role: .destructive,
                                    action: .confirmDeletion(id: contactId),
                                    label: { TextState("Delete") }
                                )
                            }
                        )
                    )
                    return .none
                    
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
}

extension ContactsFeature {
    
    @Reducer(state: .equatable)
    enum Destination {
        case addContact(AddContactFeature)
        case alert(AlertState<ContactsFeature.Action.Alert>)
    }
    
}
