//
//  DispatchHSM06.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +--------------------------------------+
 |       +----+                         |
 |       | S1 |                         |
 |       +----+---------------------+   |
 |       | S11             *        |   |
 |       |   +-------+   +-v-----+  |   |
 |       |   | S111  |   | S112  |  |   |
 |    +------O       |   |       |  |   |
 |    |  |   +-------+   +-------+  |   |
 |    |  |                          |   |
 |  +-J1 +--------------------------+   |
 |  | |  | S12 H                    |   |
 |  | |  |   +-------+   +-------+  |   |
 |  | +------O S121  |   | S122  |  |   |
 |  |    |   |       |   |       |  |   |
 |  |    |   +-------+   +-------+  |   |
 |  |    |                          |   |
 |  |    +--------------------------+   |
 |  |                                   |
 |  |    +--------------------------+   |
 |  +----> S2                       |   |
 |       |                          |   |
 |       +--------------------------+   |
 +--------------------------------------+

 */

final class DispatchHSM06: TopState<DispatchHSM06.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
    }
    final class S1: Cluster<DispatchHSM06, DispatchHSM06> {
        final class S11: State<S1, DispatchHSM06> {
            final class S111: State<S11, DispatchHSM06> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            final class S112: State<S11, DispatchHSM06> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            let s111 = S111()
            let s112 = S112()
            override func initialize() {
                bind(s111, s112)
                initial = s112
            }
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return event.nextState.map { .init(to: $0) }
            }
        }
        final class S12: State<S1, DispatchHSM06> {
            final class S121: State<S12, DispatchHSM06> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            final class S122: State<S12, DispatchHSM06> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            let s121 = S121()
            let s122 = S122()
            override func initialize() {
                bind(s121, s122)
                historyMode = .shallow
            }
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return event.nextState.map { .init(to: $0) }
            }
        }
        let s11 = S11()
        let s12 = S12()
        override func initialize() {
            bind(s11, s12)
        }
    }
    final class S2: State<DispatchHSM06, DispatchHSM06> {
        final class J1: Join<S2, DispatchHSM06> {
            override func initialize() {
                bindIncomings(top.s1.s11.s111, top.s1.s12.s121)
            }
        }
        let j1 = J1()
        override func initialize() {
            bind(j1)
        }
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
        super.init()
    }
    override func initialize() {
        bind(s1, s2)
    }
    override func handle(_ event: Event) -> Transition? {
        defer { extended.transitionSequence.append(.handle(self)) }
        return event.nextState.map { .init(to: $0) }
    }
}
