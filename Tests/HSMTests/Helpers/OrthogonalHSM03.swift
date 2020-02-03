//
//  OrthogonalHSM03.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------------------------------------------+
 |                                               |
 |   +----+                                      |
 |   | S0 |                                      |
 |   +----+----------------------------------+   |
 |   | S1                                    |   |
 |   |   +---------+   +---------+           |   |
 |   |   | S11     |   | S12     |           |   |
 |   |   |         |   |         |           |   |
 |   |   +---------+   +---------+           |   |
 |   |                                       |   |
 |   +---------------------------------------+   |
 |   | S2                                    |   |
 |   |   +-----------------+   +---------+   |   |
 |   |   | S21             |   | S22     |   |   |
 |   |   |   +---------+   |   |         |   |   |
 |   |   |   | S211    |   |   +---------+   |   |
 |   |   |   |         |   |                 |   |
 |   |   |   +---------+   |                 |   |
 |   |   |                 |                 |   |
 |   |   +-----------------+                 |   |
 |   |                                       |   |
 |   +---------------------------------------+   |
 |   | S3                                    |   |
 |   |                                       |   |
 |   +---------------------------------------+   |
 |                                               |
 |   +---------+                                 |
 |   | S4      |                                 |
 |   |         |                                 |
 |   +---------+                                 |
 |                                               |
 +-----------------------------------------------+

 */

final class OrthogonalHSM03: TopState<Event> {
    final class S0: Cluster<OrthogonalHSM03, OrthogonalHSM03> {
        final class S1: State<S0, OrthogonalHSM03> {
            final class S11: State<S1, OrthogonalHSM03> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S12: State<S1, OrthogonalHSM03> {
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
        final class S2: State<S0, OrthogonalHSM03> {
            final class S21: State<S2, OrthogonalHSM03> {
                final class S211: State<S21, OrthogonalHSM03> {
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                let s211 = S211()
                override func initialize() {
                    bind(s211)
                }
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S22: State<S2, OrthogonalHSM03> {
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
        final class S3: State<S0, OrthogonalHSM03> {
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s1 = S1()
        let s2 = S2()
        let s3 = S3()
        override func initialize() {
            bind(s1, s2, s3)
        }
    }
    final class S4: State<OrthogonalHSM03, OrthogonalHSM03> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s0 = S0()
    let s4 = S4()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s0, s4)
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
