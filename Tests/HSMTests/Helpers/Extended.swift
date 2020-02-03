//
//  Extended.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import HSM

final class Extended {
    enum TransitionSequenceEntry: Equatable {
        case exit(StateBasic)
        case entry(StateBasic)
        case handle(StateBasic) // Note: this one does not really relate to the transition sequence
        case transitionAction
        static func == (lhs: TransitionSequenceEntry, rhs: TransitionSequenceEntry) -> Bool {
            switch (lhs, rhs) {
            case (.exit(let l), .exit(let r)): return l === r
            case (.entry(let l), .entry(let r)): return l === r
            case (.handle(let l), .handle(let r)): return l === r
            case (.transitionAction, .transitionAction): return true
            default: return false
            }
        }
    }
    // A registry for transition (and also signal handling) sequence.
    var transitionSequence: [TransitionSequenceEntry] = []
    func reset() {
        transitionSequence = []
    }
}
