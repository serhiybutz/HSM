//
//  JoinHSM01.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------------------+
 |       +----+          |
 |       | S1 |          |
 |       +----+------+   |
 |       | S11       |   |
 |    +--O           |   |
 |    |  |           |   |
 |  +-J1 +-----------+   |
 |  | |  | S12       |   |
 |  | +--O           |   |
 |  |    |           |   |
 |  |    +-----------+   |
 |  |                    |
 |  |    +-----------+   |
 |  +----> S2        |   |
 |       |           |   |
 |       +-----------+   |
 +-----------------------+

 */

final class JoinHSM01: TopState<Event> {
    final class S1: Cluster<JoinHSM01, JoinHSM01> {
        final class S11: State<S1, JoinHSM01> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S12: State<S1, JoinHSM01> {
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
    }
    final class S2: State<JoinHSM01, JoinHSM01> {
        final class J1: Join<S2, JoinHSM01> {
            override func initialize() {
                bindIncomings(top.s1.s11, top.s1.s12)
            }
        }
        let j1 = J1()
        override func initialize() {
            bind(j1)
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
