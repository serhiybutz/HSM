//
//  InitialHSM01.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

/*

 x-----x
 |     |
 |     |
 x-----x

 */

final class InitialHSM01: TopState<Event> {
    let extended: Extended
    init(_ extended: Extended) {
        self.extended = extended
        super.init(eventDispatcherType: SyncEventDispatcher<Event>.self)
    }
    override func entry() {
        extended.transitionSequence.append(.entry(self))
    }
    override func exit() {
        extended.transitionSequence.append(.exit(self))
    }
}
