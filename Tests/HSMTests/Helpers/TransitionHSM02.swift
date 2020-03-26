//
//  TransitionHSM02.swift
//  HSM
//
//  Created by Serge Bouts on 3/26/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------------------------+
 |     *                       |
 |  +--v--+  +-----+  +-----+  |
 |  | S1  |  | S2  |  | S3  |  |
 |  |     |  |     |  |     |  |
 |  +-----+  +--O--+  +-----+  |
 |              | always ^     |
 |              +--------+     |
 +-----------------------------+

 */

final class TransitionHSM02: TopState<TransitionHSM02.Event> {
    struct Event: EventProtocol {
        let nextState: StateProtocol?
        let action: (() -> Void)?
        init(nextState: StateProtocol? = nil, action: (() -> Void)? = nil) {
            self.nextState = nextState
            self.action = action
        }
    }
    final class S1: State<TransitionHSM02, TransitionHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S2: State<TransitionHSM02, TransitionHSM02> {
        lazy var alwaysTransAction: (() -> Void)? = {
            self.top.extended.transitionSequence.append(.always)
        }
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
        override func always() -> Transition? {
            return Transition(to: superior.s3, action: alwaysTransAction)
        }
    }
    final class S3: State<TransitionHSM02, TransitionHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
        override func always() -> Transition? {
            return nil
        }
    }
    let extended: Extended
    let s1 = S1()
    let s2 = S2()
    let s3 = S3()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s1, s2, s3)
        initial = s1
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
