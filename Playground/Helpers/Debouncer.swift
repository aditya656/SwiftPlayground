//
//  Debouncer.swift
//  Playground
//
//  Created by Aditya Patole on 19/08/25.
//



import SwiftUI
import Combine

class Debouncer: ObservableObject {
    private var cancellable: AnyCancellable?
    private let queue: DispatchQueue
    private let delay: TimeInterval

    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }

    func run(action: @escaping () -> Void) {
        cancellable?.cancel()
        cancellable = Just(())
            .delay(for: .seconds(delay), scheduler: queue)
            .sink { _ in
                action()
            }
    }
}
