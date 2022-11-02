//
//  Transitioning.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

protocol Transitioning: InternalReferencing {}

extension Transitioning {
    func transition(to state: StateBasic, action: (() -> Void)? = nil) {
        let `internal` = (state as! InternalReferencing).internal!
        `internal`.transition(to: (state as! InternalReferencing).`internal`, action: action)
    }
}
