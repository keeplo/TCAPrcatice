//
//  AlertState+.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import Foundation
import ComposableArchitecture

extension AlertState where Action == ContactsFeature.Action.Alert {
    
    static func deleteComfirmation(id: UUID) -> Self {
        .init(
            title: { TextState("Are you sure?") },
            actions: {
                ButtonState(
                    role: .destructive,
                    action: .confirmDeletion(id: .init(1)),
                    label: { TextState("Delete") }
                )
            }
        )
    }
    
}

extension AlertState where Action == ContactDetailFeature.Action.Alert {
    
    static let confirmDeletion = Self(
        title: { TextState("Are you sure?") },
        actions: {
            ButtonState(
                role: .destructive,
                action: .confirmDeletion,
                label: { TextState("Delete") }
            )
        }
    )
    
}
