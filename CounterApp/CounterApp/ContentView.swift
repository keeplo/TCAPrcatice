//
//  ContentView.swift
//  CounterApp
//
//  Created by 김용우 on 8/6/24.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
              Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
              HStack {
                Button("-") {
                  store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                  store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
              }
              Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
                store.send(.toggleTimerButtonTapped)
              }
              .font(.largeTitle)
              .padding()
              .background(Color.black.opacity(0.1))
              .cornerRadius(10)
              
              Button("Fact") {
                store.send(.factButtonTapped)
              }
              .font(.largeTitle)
              .padding()
              .background(Color.black.opacity(0.1))
              .cornerRadius(10)
              
              if store.isLoading {
                ProgressView()
              } else if let fact = store.fact {
                Text(fact)
                  .font(.largeTitle)
                  .multilineTextAlignment(.center)
                  .padding()
              }
            }
    }
}

#Preview {
    ContentView(
        store: Store(
            initialState: CounterFeature.State(),
            reducer: { CounterFeature() }
        )
    )
}
