//
//  ForkHSM03.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +---------------------------------------------------------------+
 |                                                               |
 |       +----+                                                  |
 |       | S1 |                                                  |
 |       +----+-----------------------------------------------+  |
 |       | S11 H*                                             |  |
 |       |   +--------------------------+   +------+          |  |
 |       |   | S111            *        |   | S112 |          |  |
 |       |   |   +-------+   +-v-----+  |   |      |          |  |
 |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
 |       |   |   |       |   |       |  |                     |  |
 |    +------>   +-------+   +-------+  |                     |  |
 |    |  |   |                          |                     |  |
 |    |  |   +--------------------------+                     |  |
 |    |  |                                                    |  |
 |    |  +----------------------------------------------------+  |
 |  +-F1 | S12 H*                                             |  |
 |  | |  |   +-----------------------------------+  +------+  |  |
 |  | |  |   | S121                              |  | S122 |  |  |
 |  | |  |   |   +----------------------------+  |  |      |  |  |
 |  | +----------> S1211 H                    |  |  +------+  |  |
 |  |    |   |   |   +--------+   +--------+  |  |            |  |
 |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
 |  |    |   |   |   |        |   |        |  |  |            |  |
 |  |    |   |   |   +--------+   +--------+  |  |            |  |
 |  |    |   |   |                            |  |            |  |
 |  |    |   |   +----------------------------+  |            |  |
 |  |    |   |                                   |            |  |
 |  |    |   +-----------------------------------+            |  |
 |  |    |                                                    |  |
 |  |    +----------------------------------------------------+  |
 |  |    | S13                                                |  |
 |  |    |   +-------+                                        |  |
 |  |    |   | S131  |                                        |  |
 |  |    |   |       |                                        |  |
 |  |    |   +-------+                                        |  |
 |  |    |                                                    |  |
 |  |    +----------------------------------------------------+  |
 |  |    +------+                                                |
 |  +----O S2   |                                                |
 |       |      |                                                |
 |       +------+                                                |
 +---------------------------------------------------------------+

 */

final class ForkHSM03: TopState<Event> {
    final class S1: Cluster<ForkHSM03, ForkHSM03> {
        final class S11: State<S1, ForkHSM03> {
            final class S111: State<S11, ForkHSM03> {
                final class S1111: State<S111, ForkHSM03> {
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                final class S1112: State<S111, ForkHSM03> {
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                let s1111 = S1111()
                let s1112 = S1112()
                override func initialize() {
                    bind(s1111, s1112)
                    initial = s1112
                }
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S112: State<S11, ForkHSM03> {
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
                historyMode = .deep
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S12: State<S1, ForkHSM03> {
            final class S121: State<S12, ForkHSM03> {
                final class S1211: State<S121, ForkHSM03> {
                    final class S12111: State<S1211, ForkHSM03> {
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    final class S12112: State<S1211, ForkHSM03> {
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    let s12111 = S12111()
                    let s12112 = S12112()
                    override func initialize() {
                        bind(s12111, s12112)
                        historyMode = .shallow
                    }
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                let s1211 = S1211()
                override func initialize() {
                    bind(s1211)
                }
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S122: State<S12, ForkHSM03> {
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
                historyMode = .deep
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }

        final class S13: State<S1, ForkHSM03> {
            final class S131: State<S13, ForkHSM03> {
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
    final class S2: State<ForkHSM03, ForkHSM03> {
        final class F1: Fork<S2, ForkHSM03> {
            override func initialize() {
                bindOutgoings(top.s1.s11.s111, top.s1.s12.s121.s1211)
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
