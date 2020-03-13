//
//  E.swift
//  HSM
//
//  Created by Serge Bouts on 3/12/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

@testable import HSM

/// A set of state refs to be used in XCT asserts for comparisson
struct E: Equatable {
    let oids: Set<Int>
    init(_ args: StateBasic...) {
        self.oids = Set(args.map {
            let `internal` = ($0 as! InternalReferencing).internal!
            return ObjectIdentifier(`internal`).hashValue
        })
    }
    init(_ args: [StateBasic]) {
        self.oids = Set(args.map {
            let `internal` = ($0 as! InternalReferencing).internal!
            return ObjectIdentifier(`internal`).hashValue
        })
    }
}
