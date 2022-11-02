//
//  InitialityTests.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class InitialityTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()

        // When

        let sut = InitialHSM01(extended)
        sut.start()

        //    #-----#
        //    |     |
        //    |     |
        //    #-----#

        // Then

        XCTAssertTrue(sut.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = InitialHSM02(extended)

        // When

        sut.start()

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    +->|     |  |
        //    |  #-----#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s0, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    |  | +-+ |  |
        //    |  #-+-v-#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    |<-+     |  |
        //    |  #-----#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  +-----+  |
        //    | *> S0  |  |
        //    |  |     |  |
        //    |  +--+--+  |
        //    |     v     |
        //    |  #-----#  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |     ^     |
        //    |  +--+--+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s0)])

        // When

        extended.reset()
        sut.s0.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  +-----+  |
        //    | *> S0  |  |
        //    |  |     |  |
        //    |  +--+--+  |
        //    |     v     |
        //    |  #-----#  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------#
        //    |           |
        //    |  #-----#  |
        //    | *> S0  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |<-+     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s0)])
    }

    func test_03() {
        // Given

        let extended = Extended()

        // When

        let sut = InitialHSM03(extended)
        sut.start()

        //    #------------------#
        //    |                  |
        //    |  +------------+  |
        //    |  | S1         |  |
        //    |  |            |  |
        //    |  +------------+  |
        //    |                  |
        //    |  #------------#  |
        //    | *> S2         |  |
        //    |  |  +------+  |  |
        //    |  |  | S21  |  |  |
        //    |  |  |      |  |  |
        //    |  |  +------+  |  |
        //    |  |            |  |
        //    |  |  #------#  |  |
        //    |  | *> S22  |  |  |
        //    |  |  |      |  |  |
        //    |  |  #------#  |  |
        //    |  |            |  |
        //    |  #------------#  |
        //    |                  |
        //    #------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s2),
                        .entry(sut.s2.s22)])

        // When

        extended.reset()
        sut.s2.s22.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------#
        //    |                   |
        //    |  #------------#   |
        //    |  | S1         |   |
        //    |  |            |<+ |
        //    |  #------------# | |
        //    |                 | |
        //    |  +------------+ | |
        //    | *> S2         | | |
        //    |  |  +------+  | | |
        //    |  |  | S21  |  | | |
        //    |  |  |      |  | | |
        //    |  |  +------+  | | |
        //    |  |            | | |
        //    |  |  +------+  | | |
        //    |  | *> S22  |  | | |
        //    |  |  |      +----+ |
        //    |  |  +------+  |   |
        //    |  |            |   |
        //    |  +------------+   |
        //    |                   |
        //    #-------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s22),
                        .exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------#
        //    |                  |
        //    |  +------------+  |
        //    |  | S1         |  |
        //    |<-+            |  |
        //    |  +------------+  |
        //    |                  |
        //    |  #------------#  |
        //    | *> S2         |  |
        //    |  |  +------+  |  |
        //    |  |  | S21  |  |  |
        //    |  |  |      |  |  |
        //    |  |  +------+  |  |
        //    |  |            |  |
        //    |  |  #------#  |  |
        //    |  | *> S22  |  |  |
        //    |  |  |      |  |  |
        //    |  |  #------#  |  |
        //    |  |            |  |
        //    |  #------------#  |
        //    |                  |
        //    #------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s22)])

        // When

        extended.reset()
        sut.s2.s22.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------#
        //    |                  |
        //    |  +------------+  |
        //    |  | S1         |  |
        //    |  |            |  |
        //    |  +------------+  |
        //    |                  |
        //    |  #------------#  |
        //    | *> S2         |  |
        //    |  |  #------#  |  |
        //    |  |  | S21  |  |  |
        //    |  |  |      |  |  |
        //    |  |  #------#  |  |
        //    |  |      ^     |  |
        //    |  |  +---+--+  |  |
        //    |  | *> S22  |  |  |
        //    |  |  |      |  |  |
        //    |  |  +------+  |  |
        //    |  |            |  |
        //    |  #------------#  |
        //    |                  |
        //    #------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s22),
                        .transitionAction,
                        .entry(sut.s2.s21)])

        // When

        extended.reset()
        sut.s2.s21.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------#
        //    |                  |
        //    |  +------------+  |
        //    |  | S1         |  |
        //    |  |            |  |
        //    |  +------------+  |
        //    |                  |
        //    |  #------------#  |
        //    | *> S2         |  |
        //    |  |  +------+  |  |
        //    |  |  | S21  |  |  |
        //    |  |<-+      |  |  |
        //    |  |  +------+  |  |
        //    |  |            |  |
        //    |  |  #------#  |  |
        //    |  | *> S22  |  |  |
        //    |  |  |      |  |  |
        //    |  |  #------#  |  |
        //    |  |            |  |
        //    |  #------------#  |
        //    |                  |
        //    #------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21),
                        .transitionAction,
                        .entry(sut.s2.s22)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------#
        //    |                  |
        //    |  +------------+  |
        //    |  | S1         |  |
        //    |  |            |  |
        //    |  +------------+  |
        //    |                  |
        //    |  #------------#  |
        //    | *> S2         |  |
        //    |  |  #------#  |  |
        //    |  |  | S21  |  |  |
        //    |  +-->      |  |  |
        //    |  |  #------#  |  |
        //    |  |            |  |
        //    |  |  +------+  |  |
        //    |  | *> S22  |  |  |
        //    |  |  |      |  |  |
        //    |  |  +------+  |  |
        //    |  |            |  |
        //    |  #------------#  |
        //    |                  |
        //    #------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s22),
                        .transitionAction,
                        .entry(sut.s2.s21)])

        // When

        extended.reset()
        sut.s2.s21.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------+
        //    |                   |
        //    |  #------------#   |
        //    |  | S1         |   |
        //    |  |            |<+ |
        //    |  #------------# | |
        //    |                 | |
        //    |  +------------+ | |
        //    | *> S2         | | |
        //    |  |  +------+  | | |
        //    |  |  | S21  +----+ |
        //    |  |  |      |  |   |
        //    |  |  +------+  |   |
        //    |  |            |   |
        //    |  |  +------+  |   |
        //    |  | *> S22  |  |   |
        //    |  |  |      |  |   |
        //    |  |  +------+  |   |
        //    |  |            |   |
        //    |  +------------+   |
        //    |                   |
        //    +-------------------+

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21),
                        .exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )


        //    #-------------------#
        //    |                   |
        //    |  +------------+   |
        //    |  | S1         |   |
        //    |  |            +-+ |
        //    |  +------------+ | |
        //    |                 | |
        //    |  #------------# | |
        //    | *> S2         | | |
        //    |  |  +------+  | | |
        //    |  |  | S21  |  |<+ |
        //    |  |  |      |  |   |
        //    |  |  +------+  |   |
        //    |  |            |   |
        //    |  |  #------#  |   |
        //    |  | *> S22  |  |   |
        //    |  |  |      |  |   |
        //    |  |  #------#  |   |
        //    |  |            |   |
        //    |  #------------#   |
        //    |                   |
        //    #-------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s22)])
    }

    func test_04() {
        // Given

        let extended = Extended()

        // When

        let sut = InitialHSM04(extended)
        sut.start()

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  +------------+  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  +------------+  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  +->|  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2.s21),
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.s21.s212.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |<-+      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])

        // When

        extended.reset()
        sut.s2.s21.transition(
            to: sut.s2.s21.s212, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  +->|      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .transitionAction,
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.s21.s212.transition(
            to: sut.s2.s21.s211,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |      ^     |  |  |
        //    |  |  |  +---+--+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s211))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .transitionAction,
                        .entry(sut.s2.s21.s211)])

        // When

        extended.reset()
        sut.s2.s21.s211.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    |  | S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |<-+      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s211),
                        .transitionAction,
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.s21.transition(
            to: sut.s2.s21.s211,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  +->|      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s211))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .transitionAction,
                        .entry(sut.s2.s21.s211)])

        // When

        extended.reset()
        sut.s2.s21.s211.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  #------------------#  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |            ^           |
        //    |  +---------|--------+  |
        //    | *> S2      |        |  |
        //    |  |  +------|-----+  |  |
        //    |  |  | S21  |     |  |  |
        //    |  |  |  +---+--+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  +------------+  |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s211),
                        .exit(sut.s2.s21),
                        .exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  +---------+--------+  |
        //    |            |           |
        //    |  #---------|--------#  |
        //    | *> S2      v        |  |
        //    |  |  #------------#  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  #------#  |  |  |
        //    |  |  |            |  |  |
        //    |  |  #------------#  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s21),
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  #------------------#  |
        //    |  | S1               |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |            ^           |
        //    |  +---------|--------+  |
        //    | *> S2      |        |  |
        //    |  |  +------+-----+  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  +------------+  |  |
        //    |  |                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .exit(sut.s2.s21),
                        .exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------#
        //    |                        |
        //    |  +------------------+  |
        //    |  | S1               |  |
        //    |<-+                  |  |
        //    |  +------------------+  |
        //    |                        |
        //    |  #------------------#  |
        //    | *> S2               |  |
        //    |  |  +------------+  |  |
        //    |  |  | S21        |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |  | S211 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  | *> S212 |  |  |  |
        //    |  |  |  |      |  |  |  |
        //    |  |  |  +------+  |  |  |
        //    |  |  |            |  |  |
        //    |  |  +------------+  |  |
        //    |  |                  |  |
        //    |  #------------------#  |
        //    |                        |
        //    #------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2)])
    }
}
