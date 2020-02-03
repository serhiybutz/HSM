//
//  DispatchHSM02.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +--------------------+
 |                    |
 |  +-----+  +-----+  |
 |  | S1  |  | S2  |  |
 |  |     |  |     |  |
 |  +-----+  +-----+  |
 |                    |
 +--------------------+

 */

final class DispatchHSM02: TopState<DispatchHSM02.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
    }
    final class S1: State<DispatchHSM02, DispatchHSM02> {
        override func handle(_ event: Event) -> Transition? {
            defer { top.extended.transitionSequence.append(.handle(self)) }
            return event.nextState.map { .init(to: $0) }
        }
    }
    final class S2: State<DispatchHSM02, DispatchHSM02> {
        override func handle(_ event: Event) -> Transition? {
            defer { top.extended.transitionSequence.append(.handle(self)) }
            return event.nextState.map { .init(to: $0) }
        }
    }
    let extended: Extended
    let s1 = S1()
    let s2 = S2()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s1, s2)
    }
    override func handle(_ event: Event) -> Transition? {
        defer { extended.transitionSequence.append(.handle(self)) }
        return event.nextState.map { .init(to: $0) }
    }
}
