//
//  LocalDispatchHSM01.swift
//  HSM
//
//  Created by Serhiy Butz on 04/19/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation
import HSM

/*

 +--------------------+
 |                    |
 |  +-----+  +-----+  |
 |  | S1  |  | S2  |  |
 |  |     |  |     |  |
 |  +-----+  +-----+  |
 |                    |
 +--------------------+

 */

final class LocalDispatchHSM01: TopState<LocalDispatchHSM01.Event> {
    enum Event: EventProtocol {
        case scenario1(completion: () -> Void),
             scenario2(completion: () -> Void),
             s1,
             s2
    }
    final class S1: State<LocalDispatchHSM01, LocalDispatchHSM01> {
        override func entry() {
            superior.extended.transitionSequence.append(.entry(self))
        }
    }
    final class S2: State<LocalDispatchHSM01, LocalDispatchHSM01> {
        override func entry() {
            superior.extended.transitionSequence.append(.entry(self))
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
    override func handle(_ event: Event) -> Transition? {
        switch event {
        case .scenario1(let completion):
            self.dispatch(.s1) { _ in
                completion()
            }
            self.dispatchLocal(.s2)
        case .scenario2(let completion):
            self.dispatchLocal(.s1)
            self.dispatch(.s2) { _ in
                completion()
            }
        case .s1:
            return Transition(to: s1)
        case .s2:
            return Transition(to: s2)
        }
        return Transition(to: nil)
    }
}
