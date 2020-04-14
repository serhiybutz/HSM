//
//  NavigationHSM03.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +--------------------------------------------------+
 |                                                  |
 |  +--------------------+  +--------------------+  |
 |  | S1                 |  | S2                 |  |
 |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
 |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
 |  |  |     |  |     |  |  |  |     |  |     |  |  |
 |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
 |  |                    |  |                    |  |
 |  +--------------------+  +--------------------+  |
 |                                                  |
 +--------------------------------------------------+

 */

final class NavigationHSM03: TopState<Event> {
    final class S1: State<NavigationHSM03, NavigationHSM03> {
        final class S11: State<S1, NavigationHSM03> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S12: State<S1, NavigationHSM03> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s11 = S11()
        let s12 = S12()
        override func initialize() {
            bind(s11, s12)
        }
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S2: State<NavigationHSM03, NavigationHSM03> {
        final class S21: State<S2, NavigationHSM03> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S22: State<S2, NavigationHSM03> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s21 = S21()
        let s22 = S22()
        override func initialize() {
            bind(s21, s22)
        }
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
