//
//  CounterFeature.swift
//  CounterApp
//
//  Created by 김용우 on 8/6/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct CounterFeature: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var count: Int = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case toggleTimerButtonTapped
        case timerTick
    }
    
    enum CancelID {
        case timer
    }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
//    고 수준 방법, 여러 다른 Reducer를 조합하는 방식으로 주로 사용
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                case .incrementButtonTapped:
                    state.count += 1
                    state.fact = nil
                    return .none
                
                case .decrementButtonTapped:
                    state.count -= 1
                    state.fact = nil
                    return .none
                
                case .factButtonTapped:
                    state.fact = nil
                    state.isLoading = true
                    return .run { [count = state.count] send in
                        try await send(.factResponse(self.numberFact.fetch(count)))
                    }
                    
                case .factResponse(let fact):
                    state.fact = fact
                    state.isLoading = false
                    return .none
                    
                case .toggleTimerButtonTapped:
                    state.isTimerRunning.toggle()
                    if state.isTimerRunning {
                        return .run { [clock] send in
                            for await _ in clock.timer(interval: .seconds(1)) {
                                await send(.timerTick)
                            }
                        }
                        .cancellable(id: CancelID.timer)
                    } else {
                        return .cancel(id: CancelID.timer)
                    }
                    
                    
                case .timerTick:
                    state.count += 1
                    state.fact = nil
                    return .none
            }
        }
    }
    
//    Default 방식 : Reducer 로직을 직접 메서드내에 구현
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//            case .incrementButtonTapped:
//                state.count += 1
//                return .none
//
//            case .decrementButtonTapped:
//                state.count -= 1
//                return .none
//        }
//    }
    
}
