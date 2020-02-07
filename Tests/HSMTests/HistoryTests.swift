//
//  HistoryTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class HistoryTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = HistoryHSM01(extended)

        // Then

        XCTAssertEqual(extended.transitionSequence,
                       [])

        // When

        sut.start()

        //    #-----------#
        //    |  H        |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H        |
        //    |  #-----#  |
        //    +->| S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
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
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so it stays active
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = HistoryHSM02(extended)

        // Then

        sut.start()

        //    #-----------#
        //    |  H*       |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H*       |
        //    |  #-----#  |
        //    +->| S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |  H*       |
        //    |  #-----#  |
        //    |<-+ S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so it just stays active
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = HistoryHSM03(extended)

        // When

        sut.start()

        //    #-------------#
        //    | H           |
        //    |   +-----+   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    |   +-----+   |
        //    |   | S2  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   +-----+   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    |   #-----#   |
        //    |   | S2  |   |
        //    +-->|     |   |
        //    |   #-----#   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   +-----+   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    |   #-----#   |
        //    |   | S2  |   |
        //    |<--+     |   |
        //    |   #-----#   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s2 in history -> so it just stays active

        // When

        extended.reset()
        sut.transition(
            to: sut.s2, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   +-----+   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    |   #-----#   |
        //    |   | S2  |   |
        //    +-->|     |   |
        //    |   #-----#   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   #-----#   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   #-----#   |
        //    |      ^      |
        //    |   +--+--+   |
        //    |   | S2  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    #-------------#

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

        //    #-------------#
        //    | H           |
        //    |   #-----#   |
        //    |<--+ S1  |   |
        //    |   |     |   |
        //    |   #-----#   |
        //    |             |
        //    |   +-----+   |
        //    |   | S2  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so it just stays active

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   +-----+   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    |   #-----#   |
        //    |   | S2  |   |
        //    +-->|     |   |
        //    |   #-----#   |
        //    |             |
        //    #-------------#

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
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------#
        //    | H           |
        //    |   #-----#   |
        //    |   | S1  |   |
        //    |   |     |   |
        //    |   #-----#   |
        //    |      ^      |
        //    |   +--+--+   |
        //    |   | S2  |   |
        //    |   |     |   |
        //    |   +-----+   |
        //    |             |
        //    #-------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])
    }

    func test_04() {
        // When

        let extended = Extended()
        let sut = HistoryHSM04(extended)

        // When

        sut.start()

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    +-->|             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2)])

        // When

        extended.reset()
        sut.s0.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |<------+     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    +-->|             |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s2)]) // s2 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .transitionAction,
                        .entry(sut.s0.s1)])

        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   |<--+     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so it must stay put

        // When

        extended.reset()
        sut.s0.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |<--+             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    +-->|             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s1)]) // s1 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s1, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .transitionAction,
                        .entry(sut.s0.s1)])

        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut.s0.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +--+--+   |   |
        //    |   |      v      |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .transitionAction,
                        .entry(sut.s0.s2)])

        // When

        extended.reset()
        sut.s0.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H        |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |<------+     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H        |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    +------>|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s1)])
    }

    // the same as test_04 but with the _deep_ history
    func test_05() {
        // When

        let extended = Extended()
        let sut = HistoryHSM05(extended)

        // When

        sut.start()

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    +-->|             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2)])

        // When

        extended.reset()
        sut.s0.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |<------+     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    +-->|             |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s2)]) // s2 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .transitionAction,
                        .entry(sut.s0.s1)])

        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   |<--+     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> so it must stay put

        // When

        extended.reset()
        sut.s0.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |<--+             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    +-->|             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s1)]) // s1 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s1, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    |   +-->|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .transitionAction, // s1 in history -> so it must stay put
                        .entry(sut.s0.s1)])
        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut.s0.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +--+--+   |   |
        //    |   |      v      |   |
        //    |   |   #-----#   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .transitionAction,
                        .entry(sut.s0.s2)])

        // When

        extended.reset()
        sut.s0.s2.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   +-------------+   |
        //    |   | S0 H*       |   |
        //    |   |   +-----+   |   |
        //    |   |   | S1  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |<------+     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   +-------------+   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2),
                        .exit(sut.s0),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------#
        //    |                     |
        //    |   #-------------#   |
        //    |   | S0 H*       |   |
        //    |   |   #-----#   |   |
        //    |   |   | S1  |   |   |
        //    +------>|     |   |   |
        //    |   |   #-----#   |   |
        //    |   |             |   |
        //    |   |   +-----+   |   |
        //    |   |   | S2  |   |   |
        //    |   |   |     |   |   |
        //    |   |   +-----+   |   |
        //    |   |             |   |
        //    |   #-------------#   |
        //    |                     |
        //    #---------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s1)])
    }

    func test_06() {
        // When

        let extended = Extended()
        let sut = HistoryHSM06(extended)

        // When

        sut.start()

        //    #------------------------------#
        //    |   H                          |
        //    |   +----------------------+   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +--------------+   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    +-->|   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +--------------+   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s01,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   +-->|   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s01)])

        // When

        extended.reset()
        sut.s0.s01.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   +----------------------+   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +-------+------+   |   |
        //    |   |           |          |   |
        //    |   +-----------|----------+   |
        //    |               v              |
        //    |   #----------------------#   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s01),
                        .exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |               ^              |
        //    |   +-----------+----------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s01)])  // s01 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s01, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   +-->|              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s01),
                        .transitionAction,
                        .entry(sut.s0.s01)])

        // When

        extended.reset()
        sut.s0.s01.transition(
            to: sut.s0.s01.s012,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   +-->|      |   |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertTrue(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s01.s012)])

        // When

        extended.reset()
        sut.s0.s01.s012.transition(
            to: sut.s0.s01,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |<--+      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s01.s012),
                        .transitionAction])

        // When

        extended.reset()
        sut.s0.s01.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |<--+              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s01 in history -> so it must enter

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s01.s011,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   +------>|      |   |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertTrue(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s01.s011)])

        // When

        extended.reset()
        sut.s0.s01.s011.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |<----------+      |   |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertTrue(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   +----------------------+   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +--------------+   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    |   #----------------------#   |
        //    |   | S1                   |   |
        //    +-->|                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s01.s011),
                        .exit(sut.s0.s01),
                        .exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   +----------------------+   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +--------------+   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    |   #----------------------#   |
        //    |   | S1                   |   |
        //    |<--+                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s1 in history -> nothing happens

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |              ^               |
        //    |   +----------+-----------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertTrue(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s0),
                        .entry(sut.s0.s01),
                        .entry(sut.s0.s01.s011)]) // s011 in history

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0.s01,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   #----------------------#   |
        //    |   | S0 H*                |   |
        //    |   |   #--------------#   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   #------#   |   |   |
        //    |   +-->|              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   #--------------#   |   |
        //    |   |                      |   |
        //    |   #----------------------#   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s01.s011),
                        .transitionAction])

        // When

        extended.reset()
        sut.s0.s01.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------#
        //    |   H                          |
        //    |   +----------------------+   |
        //    |   | S0 H*                |   |
        //    |   |   +--------------+   |   |
        //    |   |   | S01          |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S011 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |<------+              |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |   | S012 |   |   |   |
        //    |   |   |   |      |   |   |   |
        //    |   |   |   +------+   |   |   |
        //    |   |   |              |   |   |
        //    |   |   +--------------+   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    |   +----------------------+   |
        //    |   | S1                   |   |
        //    |   |                      |   |
        //    |   +----------------------+   |
        //    |                              |
        //    #------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s01.isActive)
        XCTAssertFalse(sut.s0.s01.s011.isActive)
        XCTAssertFalse(sut.s0.s01.s012.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction]) // s0, s011 in history -> so nothing happens
    }
}
