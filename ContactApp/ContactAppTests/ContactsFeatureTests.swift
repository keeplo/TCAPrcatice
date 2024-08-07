//
//  ContactsFeatureTests.swift
//  ContactAppTests
//
//  Created by 김용우 on 8/7/24.
//

import ComposableArchitecture

import XCTest
@testable import ContactApp

final class ContactsFeatureTests: XCTestCase {

    @MainActor
    func testAppFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(
                    contact: .init(id: .init(0), name: "")
                )
            )
        }
        await store.send(\.destination.addContact.setName, "Blob Jr.") {
            $0.destination?.addContact?.contact.name = "Blob Jr."
        }
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.receive(
            \.destination.addContact.delegate.saveContact, 
             Contact(id: .init(0), name: "Blob Jr.")
        ) {
            $0.contacts = [
                Contact(id: .init(0), name: "Blob Jr.")
            ]
        }
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    @MainActor
    func testAddFlow_NonExhaustive() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addContact.setName, "Blob Jr.")
        await store.send(\.destination.addContact.saveButtonTapped)
        await store.skipReceivedActions()
        store.assert {
            $0.contacts = [
                .init(id: .init(0), name: "Blob Jr.")
            ]
            $0.destination = nil
        }
    }
    
    @MainActor
    func testDeleteContact() async {
        let store = TestStore(
            initialState: ContactsFeature.State(
                contacts: [
                    .init(id: .init(0), name: "Blob"),
                    .init(id: .init(1), name: "Blob Jr.")
                ]
            )
        ) {
            ContactsFeature()
        }
        
        let deletingId = UUID(1)
        
        await store.send(.deleteButtonTapped(id: deletingId)) {
            $0.destination = .alert(.deleteComfirmation(id: deletingId))
        }
        await store.send(.destination(.presented(.alert(.confirmDeletion(id: deletingId))))) {
            $0.contacts.remove(id: deletingId)
            $0.destination = nil
        }
    }
    
}
