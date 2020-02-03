//
//  InitialHSM02.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------+
 |           |
 |  +-----+  |
 | *> S0  |  |
 |  |     |  |
 |  +-----+  |
 |           |
 |  +-----+  |
 |  | S1  |  |
 |  |     |  |
 |  +-----+  |
 |           |
 +-----------+

 */

final class InitialHSM02: TopState<Event> {
    final class S0: State<InitialHSM02, InitialHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S1: State<InitialHSM02, InitialHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s0 = S0()
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s0, s1)
        initial = s0
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
