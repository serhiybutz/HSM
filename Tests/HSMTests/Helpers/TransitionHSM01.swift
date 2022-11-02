//
//  TransitionHSM01.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
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

final class TransitionHSM01: TopState<TransitionHSM01.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
        let action: (() -> Void)?
        init(nextState: StateProtocol? = nil, action: (() -> Void)? = nil) {
            self.nextState = nextState
            self.action = action
        }
    }
    final class S1: State<TransitionHSM01, TransitionHSM01> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
        override func handle(_ event: Event) -> Transition? {
            return Transition(to: event.nextState, action: event.action)
        }
    }
    final class S2: State<TransitionHSM01, TransitionHSM01> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
        override func handle(_ event: Event) -> Transition? {
            return Transition(to: event.nextState, action: event.action)
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
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
    override func handle(_ event: Event) -> Transition? {
        return Transition(to: event.nextState, action: event.action)
    }
}
