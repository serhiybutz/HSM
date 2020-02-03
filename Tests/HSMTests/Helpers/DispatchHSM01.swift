//
//  DispatchHSM01.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 +-----------+
 |           |
 |  +-----+  |
 |  | S1  |  |
 |  |     |  |
 |  +-----+  |
 |           |
 +-----------+

 */

final class DispatchHSM01: TopState<DispatchHSM01.Event> {
    struct Event: EventProtocol {}
    final class S1: State<DispatchHSM01, DispatchHSM01> {}
    let extended: Extended
    let s1 = S1()
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func initialize() {
        bind(s1)
    }
    override func handle(_ event: Event) -> Transition? {
        defer { extended.transitionSequence.append(.handle(self)) }
        return .init(to: s1)
    }
}
