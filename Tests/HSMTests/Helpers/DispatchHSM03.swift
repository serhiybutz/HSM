//
//  DispatchHSM03.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +--------------------------+
 |                          |
 |  +--------------------+  |
 |  | S1         *       |  |
 |  |  +-----+  +v----+  |  |
 |  |  | S11 |  | S12 |  |  |
 |  |  |     |  |     |  |  |
 |  |  +-----+  +-----+  |  |
 |  |                    |  |
 |  +--------------------+  |
 |                          |
 +--------------------------+

 */

final class DispatchHSM03: TopState<DispatchHSM03.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
    }
    final class S1: State<DispatchHSM03, DispatchHSM03> {
        final class S11: State<S1, DispatchHSM03> {
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return nil
            }
        }
        final class S12: State<S1, DispatchHSM03> {
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return nil
            }
        }
        let s11 = S11()
        let s12 = S12()
        override func initialize() {
            bind(s11, s12)
            initial = s12
        }
        override func handle(_ event: Event) -> Transition? {
            defer { top.extended.transitionSequence.append(.handle(self)) }
            return event.nextState.map { .init(to: $0) }
        }
    }
    let extended: Extended
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s1)
    }
    override func handle(_ event: Event) -> Transition? {
        defer { extended.transitionSequence.append(.handle(self)) }
        return event.nextState.map { .init(to: $0) }
    }
}
