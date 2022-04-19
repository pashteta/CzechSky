//
//  Combine+Extensions .swift
//  Czech Sky
//
//  Created by Pavel Okhrimenko on 14.04.2022.
//

import Combine

extension Combine.Subscribers {
    public class MergeSink<InputType>: Subscriber, Cancellable {
        private let inputHandler: (InputType) -> Void
        private var subscriptions = [Subscription]()
        
        public init(inputHandler: @escaping (InputType) -> Void) {
            self.inputHandler = inputHandler
        }
        
        public func receive(subscription: Subscription) {
            subscriptions.append(subscription)
            subscription.request(.unlimited)
        }
        
        public func receive(_ input: InputType) -> Subscribers.Demand {
            inputHandler(input)
            return .unlimited
        }
        
        public func receive(completion: Subscribers.Completion<Never>) {
            // We should not cancel subscriptions on any event from publishers
        }
        
        // Cancels all subscriptions if cancel any of publishers cancels subscription
        public func cancel() {
            subscriptions.forEach { $0.cancel() }
            subscriptions.removeAll()
        }
    }
}

extension Subscribers.MergeSink {
    /// Allows to use one subscriber for two publishers with different type of published value
    public func map<MappedInput>(_ mappingClosure: @escaping (MappedInput) -> Input) -> Subscribers.MergeSink<MappedInput> {
        return Subscribers.MergeSink<MappedInput> { [weak self] mappedValue in
            _ = self?.receive(mappingClosure(mappedValue))
        }
    }
}

public extension Subscriber where Self.Input == Void {
    func send() {
        _ = receive(())
    }
}

public extension Subscriber {
    func send(_ input: Input) {
        _ = receive(input)
    }
}
