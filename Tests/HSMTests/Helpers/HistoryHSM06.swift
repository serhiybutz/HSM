//
//  HistoryHSM06.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +------------------------------+
 |   H                          |
 |   +----------------------+   |
 |   | S0 H*                |   |
 |   |   +--------------+   |   |
 |   |   | S01          |   |   |
 |   |   |   +------+   |   |   |
 |   |   |   | S011 |   |   |   |
 |   |   |   |      |   |   |   |
 |   |   |   +------+   |   |   |
 |   |   |              |   |   |
 |   |   |   +------+   |   |   |
 |   |   |   | S012 |   |   |   |
 |   |   |   |      |   |   |   |
 |   |   |   +------+   |   |   |
 |   |   |              |   |   |
 |   |   +--------------+   |   |
 |   |                      |   |
 |   +----------------------+   |
 |                              |
 |   +----------------------+   |
 |   | S1                   |   |
 |   |                      |   |
 |   +----------------------+   |
 |                              |
 +------------------------------+

 */

final class HistoryHSM06: TopState<Event> {
    final class S0: State<HistoryHSM06, HistoryHSM06> {
        final class S01: State<S0, HistoryHSM06> {
            final class S011: State<S01, HistoryHSM06> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            final class S012: State<S01, HistoryHSM06> {
                override func entry() {
                    top.extended.transitionSequence.append(.entry(self))
                }
                override func exit() {
                    top.extended.transitionSequence.append(.exit(self))
                }
            }
            let s011 = S011()
            let s012 = S012()
            override func initialize() {
                bind(s011, s012)
            }
            override func entry() {
                top.extended.transitionSequence.append(.entry(self))
            }
            override func exit() {
                top.extended.transitionSequence.append(.exit(self))
            }
        }
        let s01 = S01()
        override func initialize() {
            bind(s01)
            historyMode = .deep
        }
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    final class S1: State<HistoryHSM06, HistoryHSM06> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s0 = S0()
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s0, s1)
        historyMode = .shallow
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
