//
//  NavigationHSM01.swift
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
 |  | S1  |  |
 |  |     |  |
 |  +-----+  |
 |           |
 +-----------+

 */

final class NavigationHSM01: TopState<Event> {
    final class S1: State<NavigationHSM01, NavigationHSM01> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s1)
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
