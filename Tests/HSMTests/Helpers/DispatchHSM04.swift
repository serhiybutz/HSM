//
//  DispatchHSM04.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------------------------------------------------------------+
 |                                                                 |
 |   +----+                                                        |
 |   | S0 |                                                        |
 |   +----+----------------------------------------------------+   |
 |   | S1   *                                                  |   |
 |   |   +--v--+                                               |   |
 |   |   | S11 |                                               |   |
 |   |   +-----+-----------+-------------------------------+   |   |
 |   |   | S111            | S112                          |   |   |
 |   |   |   +---------+   |   +---------+   +---------+   |   |   |
 |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
 |   |   |   |         |   |   |         |   |         |   |   |   |
 |   |   |   +---------+   |   +---------+   +---------+   |   |   |
 |   |   |                 |                               |   |   |
 |   |   +-----------------+-------------------------------+   |   |
 |   |                                                         |   |
 |   +---------------------------------------------------------+   |
 |   | S2                                                      |   |
 |   |   +--------+   +--------+                               |   |
 |   |   | S21    |   | S22    |                               |   |
 |   |   |        |   |        |                               |   |
 |   |   +--------+   +--------+                               |   |
 |   |                                                         |   |
 |   +---------------------------------------------------------+   |
 |                                                                 |
 |   +---------+                                                   |
 |   | S3      |                                                   |
 |   |         |                                                   |
 |   +---------+                                                   |
 |                                                                 |
 +-----------------------------------------------------------------+

 */

final class DispatchHSM04: TopState<DispatchHSM04.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
    }
    final class S0: Cluster<DispatchHSM04, DispatchHSM04> {
        final class S1: State<S0, DispatchHSM04> {
            final class S11: Cluster<S1, DispatchHSM04> {
                final class S111: State<S11, DispatchHSM04> {
                    final class S1111: State<S111, DispatchHSM04> {
                        override func handle(_ event: Event) -> Transition? {
                            defer { top.extended.transitionSequence.append(.handle(self)) }
                            return event.nextState.map { .init(to: $0) }
                        }
                    }
                    let s1111 = S1111()
                    override func initialize() {
                        bind(s1111)
                    }
                    override func handle(_ event: Event) -> Transition? {
                        defer { top.extended.transitionSequence.append(.handle(self)) }
                        return event.nextState.map { .init(to: $0) }
                    }
                }
                final class S112: State<S11, DispatchHSM04> {
                    final class S1121: State<S112, DispatchHSM04> {
                        override func handle(_ event: Event) -> Transition? {
                            defer { top.extended.transitionSequence.append(.handle(self)) }
                            return event.nextState.map { .init(to: $0) }
                        }
                    }
                    final class S1122: State<S112, DispatchHSM04> {
                        override func handle(_ event: Event) -> Transition? {
                            defer { top.extended.transitionSequence.append(.handle(self)) }
                            return event.nextState.map { .init(to: $0) }
                        }
                    }
                    let s1121 = S1121()
                    let s1122 = S1122()
                    override func initialize() {
                        bind(s1121, s1122)
                    }
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
            }
            let s11 = S11()
            override func initialize() {
                bind(s11)
                initial = s11
            }
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return event.nextState.map { .init(to: $0) }
            }
        }
        final class S2: State<S0, DispatchHSM04> {
            final class S21: State<S2, DispatchHSM04> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            final class S22: State<S2, DispatchHSM04> {
                override func handle(_ event: Event) -> Transition? {
                    defer { top.extended.transitionSequence.append(.handle(self)) }
                    return event.nextState.map { .init(to: $0) }
                }
            }
            let s21 = S21()
            let s22 = S22()
            override func initialize() {
                bind(s21, s22)
            }
            override func handle(_ event: Event) -> Transition? {
                defer { top.extended.transitionSequence.append(.handle(self)) }
                return event.nextState.map { .init(to: $0) }
            }
        }
        let s1 = S1()
        let s2 = S2()
        override func initialize() {
            bind(s1, s2)
        }
    }
    final class S3: State<DispatchHSM04, DispatchHSM04> {
        override func handle(_ event: Event) -> Transition? {
            defer { top.extended.transitionSequence.append(.handle(self)) }
            return event.nextState.map { .init(to: $0) }
        }
    }
    let extended: Extended
    let s0 = S0()
    let s3 = S3()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s0, s3)
    }
    override func handle(_ event: Event) -> Transition? {
        defer { extended.transitionSequence.append(.handle(self)) }
        return event.nextState.map { .init(to: $0) }
    }
}
