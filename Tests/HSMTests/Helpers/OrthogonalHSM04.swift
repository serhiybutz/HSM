//
//  OrthogonalHSM04.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------------------------------------------------------------+
 |                                                                 |
 |   +----+                                                        |
 |   | S0 |                                                        |
 |   +----+----------------------------------------------------+   |
 |   | S1   *                                                  |   |
 |   |   +--v--+                                               |   |
 |   |   | S11 |                                               |   |
 |   |   +-----+-----------+-------------------------------+   |   |
 |   |   | S111            | S112                          |   |   |
 |   |   |   +---------+   |   +---------+   +---------+   |   |   |
 |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
 |   |   |   |         |   |   |         |   |         |   |   |   |
 |   |   |   +---------+   |   +---------+   +---------+   |   |   |
 |   |   |                 |                               |   |   |
 |   |   +-----------------+-------------------------------+   |   |
 |   |                                                         |   |
 |   +---------------------------------------------------------+   |
 |   | S2                                                      |   |
 |   |   +--------+   +--------+                               |   |
 |   |   | S21    |   | S22    |                               |   |
 |   |   |        |   |        |                               |   |
 |   |   +--------+   +--------+                               |   |
 |   |                                                         |   |
 |   +---------------------------------------------------------+   |
 |                                                                 |
 |   +---------+                                                   |
 |   | S3      |                                                   |
 |   |         |                                                   |
 |   +---------+                                                   |
 |                                                                 |
 +-----------------------------------------------------------------+

 */

final class OrthogonalHSM04: TopState<Event> {
    final class S0: Cluster<OrthogonalHSM04, OrthogonalHSM04> {
        final class S1: State<S0, OrthogonalHSM04> {
            final class S11: Cluster<S1, OrthogonalHSM04> {
                final class S111: State<S11, OrthogonalHSM04> {
                    final class S1111: State<S111, OrthogonalHSM04> {
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    let s1111 = S1111()
                    override func initialize() {
                        bind(s1111)
                    }
                    override func entry() {
                        top.extended.transitionSequence.append(.entry(self))
                    }
                    override func exit() {
                        top.extended.transitionSequence.append(.exit(self))
                    }
                }
                final class S112: State<S11, OrthogonalHSM04> {
                    final class S1121: State<S112, OrthogonalHSM04> {
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    final class S1122: State<S112, OrthogonalHSM04> {
                        override func entry() {
                            top.extended.transitionSequence.append(.entry(self))
                        }
                        override func exit() {
                            top.extended.transitionSequence.append(.exit(self))
                        }
                    }
                    let s1121 = S1121()
                    let s1122 = S1122()
                    override func initialize() {
                        bind(s1121, s1122)
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
                }
            }
            let s11 = S11()
            override func initialize() {
                bind(s11)
                initial = s11
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        final class S2: State<S0, OrthogonalHSM04> {
            final class S21: State<S2, OrthogonalHSM04> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S22: State<S2, OrthogonalHSM04> {
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
        let s1 = S1()
        let s2 = S2()
        override func initialize() {
            bind(s1, s2)
        }
    }
    final class S3: State<OrthogonalHSM04, OrthogonalHSM04> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s0 = S0()
    let s3 = S3()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s0, s3)
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
