//
//  NavigationHSM02.swift
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

final class NavigationHSM02: TopState<Event> {
    final class S1: State<NavigationHSM02, NavigationHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S2: State<NavigationHSM02, NavigationHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
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
}
