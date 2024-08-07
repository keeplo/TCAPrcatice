//
//  ContactDetailFeature.swift
//  ContactApp
//
//  Created by 김용우 on 8/7/24.
//

import ComposableArchitecture

@Reducer
struct ContactDetailFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        let contact: Contact
    }
    
    enum Action {
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)
        case deleteButtonTapped
        
        enum Alert {
            case confirmDeletion
        }
        enum Delegate {
            case confirmDeletion
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .alert(.presented(.confirmDeletion)):
                    return .run { send in
                        await send(.delegate(.confirmDeletion))
                        await self.dismiss()
                    }
                    
                case .alert:
                    return .none
                    
                case .delegate:
                    return .none
                    
                case .deleteButtonTapped:
                    state.alert = .confirmDeletion
                    return .none
                    
            }
        }
    }
}
