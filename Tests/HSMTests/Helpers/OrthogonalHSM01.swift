//
//  OrthogonalHSM01.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +----------------+
 |                |
 |  +----+        |
 |  | S0 |        |
 |  +----+-----+  |
 |  | S1       |  |
 |  |          |  |
 |  +----------+  |
 |  | S2       |  |
 |  |          |  |
 |  +----------+  |
 |                |
 +----------------+

 */

final class OrthogonalHSM01: TopState<Event> {
    final class S0: Cluster<OrthogonalHSM01, OrthogonalHSM01> {
        final class S1: State<S0, OrthogonalHSM01> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S2: State<S0, OrthogonalHSM01> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s1 = S1()
        let s2 = S2()
        override func initialize() {
            bind(s1, s2)
        }
    }
    let extended: Extended
    let s0 = S0()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s0)
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
