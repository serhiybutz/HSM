//
//  DispatchHSM05.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +------------------------------------+
 |                                    |
 |       +----+                       |
 |       | S1 |                       |
 |       +----+--------------------+  |
 |       | S11                     |  |
 |       | +------+   +------+     |  |
 |       | | S111 |   | S112 |     |  |
 |    +---->      |   |      |     |  |
 |    |  | +------+   +------+     |  |
 |    |  |                         |  |
 |    |  +-------------------------+  |
 |  +-F1 | S12                     |  |
 |  | |  | +-----------+  +------+ |  |
 |  | |  | | S121      |  | S122 | |  |
 |  | |  | | +-------+ |  |      | |  |
 |  | +------> S1211 | |  +------+ |  |
 |  |    | | |       | |           |  |
 |  |    | | +-------+ |           |  |
 |  |    | |           |           |  |
 |  |    | +-----------+           |  |
 |  |    |                         |  |
 |  |    +-------------------------+  |
 |  |                                 |
 |  |    +------+                     |
 |  +----O S2   |                     |
 |       |      |                     |
 |       +------+                     |
 |                                    |
 +------------------------------------+

 */

final class DispatchHSM05: TopState<DispatchHSM05.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
    }
    final class S1: Cluster<DispatchHSM05, DispatchHSM05> {
        final class S11: State<S1, DispatchHSM05> {
            final class S111: State<S11, DispatchHSM05> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            final class S112: State<S11, DispatchHSM05> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            let s111 = S111()
            let s112 = S112()
            override func initialize() {
                bind(s111, s112)
            }
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return event.nextState.map { .init(to: $0) }
            }
        }

        final class S12: State<S1, DispatchHSM05> {
            final class S121: State<S12, DispatchHSM05> {
                final class S1211: State<S121, DispatchHSM05> {
                    override func handle(_ event: Event) -> Transition? {
                        defer { top.extended.transitionSequence.append(.handle(self)) }
                        return event.nextState.map { .init(to: $0) }
                    }
                }
                let s1211 = S1211()
                override func initialize() {
                    bind(s1211)
                }
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            final class S122: State<S12, DispatchHSM05> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            let s121 = S121()
            let s122 = S122()
            override func initialize() {
                bind(s121, s122)
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
    final class S2: State<DispatchHSM05, DispatchHSM05> {
        final class F1: Fork<S2, DispatchHSM05> {
            override func initialize() {
                bindOutgoings(top.s1.s11.s111, top.s1.s12.s121.s1211)
            }
        }
        let f1 = F1()
        override func initialize() {
            bind(f1)
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
