//
//  AnyState.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

@testable import HSM

struct AnyState: Equatable, CustomStringConvertible, CustomDebugStringConvertible {
    var description: String { "\(state)" }
    var debugDescription: String { "\(state)" }
    static func == (lhs: AnyState, rhs: AnyState) -> Bool {
        lhs.state === rhs.state
    }
    let state: StateBasic
    init(_ state: StateBasic) {
        self.state = state
    }
}
