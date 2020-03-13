//
//  InitialHistoryTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class InitialHistoryTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = InitialNavigationHSM01(extended)

        // When

        sut.start()

        //    #-----------#
        //    |  H        |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    |  #-----#  |
        //    | *> S2  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H        |
        //    |  #-----#  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |     ^     |
        //    |  +--+--+  |
        //    | *> S2  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H        |
        //    |  #-----#  |
        //    |<-+ S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S2  |  |
        //    |*->     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so nothing changes

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H        |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    |  #-----#  |
        //    | *> S2  |  |
        //    +->|     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H        |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    |  #-----#  |
        //    | *> S2  |  |
        //    |<-+     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s2 in history -> so nothing changes
    }
}
