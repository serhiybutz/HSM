//
//  QueryTests.swift
//  HSM
//
//  Created by Serge Bouts on 3/28/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class QueryTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = OrthogonalHSM02(extended)

        // When

        sut.start()

        //    #-------------------------#
        //    |                         |
        //    |   +----+                |
        //    |   | S0 |                |
        //    |   +----+------------+   |
        //    |   | S1              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   +-----------------+   |
        //    |   | S2              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   +-----------------+   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        // Then: Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut)

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut)

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssertNil(sut.s0.s1.activeStateInRegion)

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssertNil(sut.s0.s1.s11.activeStateInRegion)

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssertNil(sut.s0.s2.activeStateInRegion)

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssertNil(sut.s0.s2.s21.activeStateInRegion)

        // When

        extended.reset()
        sut.transition(to: sut.s0)

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    +-->| S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |   | S2              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1,
                         sut.s0.s2))

        // Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut.s0) // changes

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut.s0) // chages

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssert(sut.s0.s1.activeStateInRegion === sut.s0.s1) // changes

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssert(sut.s0.s1.s11.activeStateInRegion === sut.s0.s1) // changes

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssert(sut.s0.s2.activeStateInRegion === sut.s0.s2) // changes

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssert(sut.s0.s2.s21.activeStateInRegion === sut.s0.s2) // changes

        // When

        extended.reset()
        sut.transition(to: sut.s0.s1) // changes nothing

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    |   | S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    |   |   +---------+   |   |
        //    +-->|   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |   | S2              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1,
                         sut.s0.s2))

        // Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssert(sut.s0.s1.activeStateInRegion === sut.s0.s1)

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssert(sut.s0.s1.s11.activeStateInRegion === sut.s0.s1)

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssert(sut.s0.s2.activeStateInRegion === sut.s0.s2)

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssert(sut.s0.s2.s21.activeStateInRegion === sut.s0.s2)

        // When

        extended.reset()
        sut.transition(to: sut.s0.s1.s11)

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    |   | S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    |   |   #---------#   |   |
        //    +------>| S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   #---------#   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |   | S2              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11, // changes
                         sut.s0.s2))

        // Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssert(sut.s0.s1.activeStateInRegion === sut.s0.s1.s11) // changes

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssert(sut.s0.s1.s11.activeStateInRegion === sut.s0.s1.s11) // changes

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssert(sut.s0.s2.activeStateInRegion === sut.s0.s2)

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssert(sut.s0.s2.s21.activeStateInRegion === sut.s0.s2)

        // When

        extended.reset()
        sut.transition(to: sut.s0.s2.s21)

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    |   | S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    |   |   #---------#   |   |
        //    |   |   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   #---------#   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |   | S2              |   |
        //    |   |   #---------#   |   |
        //    +------>| S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   #---------#   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertTrue(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11,
                         sut.s0.s2.s21/* changes */))

        // Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut.s0)

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssert(sut.s0.s1.activeStateInRegion === sut.s0.s1.s11)

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssert(sut.s0.s1.s11.activeStateInRegion === sut.s0.s1.s11)

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssert(sut.s0.s2.activeStateInRegion === sut.s0.s2.s21) // changes

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssert(sut.s0.s2.s21.activeStateInRegion === sut.s0.s2.s21) // changes

        // When

        extended.reset()
        sut.transition(to: sut)

        //    #-------------------------#
        //    |                         |
        //    |   +----+                |
        //    |   | S0 |                |
        //    |   +----+------------+   |
        //    |   | S1              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   +-----------------+   |
        //    |   | S2              |   |
        //    |   |   +---------+   |   |
        //    |   |   | S21     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   +-----------------+   |
        //    |                         |
        //    #-------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut)) // changes

        // Then: Queries

        XCTAssertNil(sut.superiorState)
        XCTAssert(sut.representsRegion)
        XCTAssert(sut.activeStateInRegion === sut) // changes

        XCTAssert(sut.s0.superiorState === sut)
        XCTAssertFalse(sut.s0.representsRegion)
        XCTAssert(sut.s0.activeStateInRegion === sut) // changes

        XCTAssert(sut.s0.s1.superiorState === sut.s0)
        XCTAssert(sut.s0.s1.representsRegion)
        XCTAssertNil(sut.s0.s1.activeStateInRegion) // changes

        XCTAssert(sut.s0.s1.s11.superiorState === sut.s0.s1)
        XCTAssert(!sut.s0.s1.s11.representsRegion)
        XCTAssertNil(sut.s0.s1.s11.activeStateInRegion) // changes

        XCTAssert(sut.s0.s2.superiorState === sut.s0)
        XCTAssert(sut.s0.s2.representsRegion)
        XCTAssertNil(sut.s0.s2.activeStateInRegion) // changes

        XCTAssert(sut.s0.s2.s21.superiorState === sut.s0.s2)
        XCTAssert(!sut.s0.s2.s21.representsRegion)
        XCTAssertNil(sut.s0.s2.s21.activeStateInRegion) // changes
    }
}
