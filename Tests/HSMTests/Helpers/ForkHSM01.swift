//
//  ForkHSM01.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +---------------------------+
 |       +----+              |
 |       | S1 |              |
 |       +----+----------+   |
 |       | S11           |   |
 |       |               |   |
 |    +-->               |   |
 |    |  |               |   |
 |  +-F1 +---------------+   |
 |  | |  | S12           |   |
 |  | +-->               |   |
 |  |    |               |   |
 |  |    |               |   |
 |  |    +---------------+   |
 |  |                        |
 |  |    +---------------+   |
 |  +----O S2            |   |
 |       |               |   |
 |       +---------------+   |
 +---------------------------+

 */

final class ForkHSM01: TopState<Event> {
    final class S1: Cluster<ForkHSM01, ForkHSM01> {
        final class S11: State<S1, ForkHSM01> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S12: State<S1, ForkHSM01> {
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
    final class S2: State<ForkHSM01, ForkHSM01> {
        final class F1: Fork<S2, ForkHSM01> {
            override func initialize() {
                bindOutgoings(top.s1.s11, top.s1.s12)
            }
        }
        let f1 = F1()
        override func initialize() {
            bind(f1)
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
