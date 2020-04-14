//
//  HistoryHSM02.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------+
 |  H*       |
 |  +-----+  |
 |  | S1  |  |
 |  |     |  |
 |  +-----+  |
 |           |
 +-----------+

 */

final class HistoryHSM02: TopState<Event> {
    final class S1: State<HistoryHSM02, HistoryHSM02> {
        override func entry() {
            top.extended.transitionSequence.append(.entry(self))
        }
        override func exit() {
            top.extended.transitionSequence.append(.exit(self))
        }
    }
    let extended: Extended
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init()
    }
    override func initialize() {
        bind(s1)
        historyMode = .deep
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
