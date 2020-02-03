//
//  JoinHSM03.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +------------------------------------------------------------------------------------------------+
 |   H     *                                                                                      |
 |       +-v--+                                                                                   |
 |       | S1 |                                                                                   |
 |       +----+--------------------------------------------------------------------------------+  |
 |       | S11             *                                                                   |  |
 |       |   +-------+   +-v----------------------------------------------------------------+  |  |
 |       |   | S111  |   | S112 H          *                                                |  |  |
 |       |   |       |   |               +-v-----+                                          |  |  |
 |       |   |       |   |               | S1122 |                                          |  |  |
 |       |   |       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
 |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
 |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
 |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
 |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
 |    +----------------------O       |   |   +---------+  |   +---------+   +---------+  |  |  |  |
 |    |  |   |       |   |   |       |   |                |                              |  |  |  |
 |    |  |   |       |   |   +-------+   +----------------+------------------------------+  |  |  |
 |    |  |   |       |   |                                                                  |  |  |
 |    |  |   +-------+   +------------------------------------------------------------------+  |  |
 |    |  |                                                                                     |  |
 |  +-J1 +-------------------------------------------------------------------------------------+  |
 |  | |  | S12 H                                                                               |  |
 |  | |  |   +--------+   +--------+                                                           |  |
 |  | +------O S121   |   | S122   |                                                           |  |
 |  |    |   |        |   |        |                                                           |  |
 |  |    |   +--------+   +--------+                                                           |  |
 |  |    |                                                                                     |  |
 |  |    +-------------------------------------------------------------------------------------+  |
 |  |    | S13                                                                                 |  |
 |  |    |   +--------+                                                                        |  |
 |  |    |   | S131   |                                                                        |  |
 |  |    |   |        |                                                                        |  |
 |  |    |   +--------+                                                                        |  |
 |  |    |                                                                                     |  |
 |  |    +-------------------------------------------------------------------------------------+  |
 |  |    +----------------------------+                                                           |
 |  +----> S2                         |                                                           |
 |       |                            |                                                           |
 |       +----------------------------+                                                           |
 +------------------------------------------------------------------------------------------------+

 */

final class JoinHSM03: TopState<Event> {
    final class S1: Cluster<JoinHSM03, JoinHSM03> {
        final class S11: State<S1, JoinHSM03> {
            final class S111: State<S11, JoinHSM03> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S112: State<S11, JoinHSM03> {
                final class S1121: State<S112, JoinHSM03> {
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                final class S1122: Cluster<S112, JoinHSM03> {
                    final class S11221: State<S1122, JoinHSM03> {
                        final class S112211: State<S11221, JoinHSM03> {
                            override func entry() {
                                top.extended.transitionSequence.append(.entry(self))
                            }
                            override func exit() {
                                top.extended.transitionSequence.append(.exit(self))
                            }
                        }
                        let s112211 = S112211()
                        override func initialize() {
                            bind(s112211)
                        }
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    final class S11222: State<S1122, JoinHSM03> {
                        final class S112221: State<S11222, JoinHSM03> {
                            override func entry() {
                                top.extended.transitionSequence.append(.entry(self))
                            }
                            override func exit() {
                                top.extended.transitionSequence.append(.exit(self))
                            }
                        }
                        final class S112222: State<S11222, JoinHSM03> {
                            override func entry() {
                                top.extended.transitionSequence.append(.entry(self))
                            }
                            override func exit() {
                                top.extended.transitionSequence.append(.exit(self))
                            }
                        }
                        let s112221 = S112221()
                        let s112222 = S112222()
                        override func initialize() {
                            bind(s112221, s112222)
                            initial = s112222
                            historyMode = .shallow
                        }
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    let s11221 = S11221()
                    let s11222 = S11222()
                    override func initialize() {
                        bind(s11221, s11222)
                    }
                }
                let s1121 = S1121()
                let s1122 = S1122()
                override func initialize() {
                    bind(s1121, s1122)
                    initial = s1122
                    historyMode = .deep
                }
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
        final class S12: State<S1, JoinHSM03> {
            final class S121: State<S12, JoinHSM03> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S122: State<S12, JoinHSM03> {
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
        final class S13: State<S1, JoinHSM03> {
            final class S131: State<S13, JoinHSM03> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            let s131 = S131()
            override func initialize() {
                bind(s131)
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
        let s13 = S13()
        override func initialize() {
            bind(s11, s12, s13)
        }
    }
    final class S2: State<JoinHSM03, JoinHSM03> {
        final class J1: Join<S2, JoinHSM03> {
            override func initialize() {
                bindIncomings(top.s1.s11.s112.s1121, top.s1.s12.s121)
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
        initial = s1
        historyMode = .shallow
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
