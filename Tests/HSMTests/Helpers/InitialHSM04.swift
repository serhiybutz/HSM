//
//  InitialHSM04.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +------------------------+
 |                        |
 |  +------------------+  |
 |  | S1               |  |
 |  |                  |  |
 |  +------------------+  |
 |                        |
 |  +------------------+  |
 | *> S2               |  |
 |  |  +------------+  |  |
 |  |  | S21        |  |  |
 |  |  |  +------+  |  |  |
 |  |  |  | S211 |  |  |  |
 |  |  |  |      |  |  |  |
 |  |  |  +------+  |  |  |
 |  |  |            |  |  |
 |  |  |  +------+  |  |  |
 |  |  | *> S212 |  |  |  |
 |  |  |  |      |  |  |  |
 |  |  |  +------+  |  |  |
 |  |  |            |  |  |
 |  |  +------------+  |  |
 |  |                  |  |
 |  +------------------+  |
 |                        |
 +------------------------+

 */

final class InitialHSM04: TopState<Event> {
    final class S1: State<InitialHSM04, InitialHSM04> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S2: State<InitialHSM04, InitialHSM04> {
        final class S21: State<S2, InitialHSM04> {
            final class S211: State<S21, InitialHSM04> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S212: State<S21, InitialHSM04> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            let s211 = S211()
            let s212 = S212()
            override func initialize() {
                bind(s211, s212)
                initial = s212
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s21 = S21()
        override func initialize() {
            bind(s21)
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
        initial = s2
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
