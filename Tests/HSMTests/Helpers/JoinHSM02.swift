//
//  JoinHSM02.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +--------------------------------------+
 |       +----+                         |
 |       | S1 |                         |
 |       +----+---------------------+   |
 |       | S11             *        |   |
 |       |   +-------+   +-v-----+  |   |
 |       |   | S111  |   | S112  |  |   |
 |    +------O       |   |       |  |   |
 |    |  |   +-------+   +-------+  |   |
 |    |  |                          |   |
 |  +-J1 +--------------------------+   |
 |  | |  | S12 H                    |   |
 |  | |  |   +-------+   +-------+  |   |
 |  | +------O S121  |   | S122  |  |   |
 |  |    |   |       |   |       |  |   |
 |  |    |   +-------+   +-------+  |   |
 |  |    |                          |   |
 |  |    +--------------------------+   |
 |  |                                   |
 |  |    +--------------------------+   |
 |  +----> S2                       |   |
 |       |                          |   |
 |       +--------------------------+   |
 +--------------------------------------+

 */

final class JoinHSM02: TopState<Event> {
    final class S1: Cluster<JoinHSM02, JoinHSM02> {
        final class S11: State<S1, JoinHSM02> {
            final class S111: State<S11, JoinHSM02> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S112: State<S11, JoinHSM02> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            let s111 = S111()
            let s112 = S112()
            override func initialize() {
                bind(s111, s112)
                initial = s112
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S12: State<S1, JoinHSM02> {
            final class S121: State<S12, JoinHSM02> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S122: State<S12, JoinHSM02> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            let s121 = S121()
            let s122 = S122()
            override func initialize() {
                bind(s121, s122)
                historyMode = .shallow
            }
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
    final class S2: State<JoinHSM02, JoinHSM02> {
        final class J1: Join<S2, JoinHSM02> {
            override func initialize() {
                bindIncomings(top.s1.s11.s111, top.s1.s12.s121)
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
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
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
