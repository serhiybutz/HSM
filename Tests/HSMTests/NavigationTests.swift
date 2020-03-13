//
//  NavigationTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class NavigationTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = NavigationHSM01(extended)

        // When

        sut.start()

        //    #-----------#
        //    |           |
        //    |  +-----+  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----+-----#
        //    |     v     |
        //    |  #-----#  |
        //    |  | S1  |  |
        //    |  |     |  |
        //    |  #-----#  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

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
        //    |           |
        //    |  +-----+  |
        //    |<-+ S1  |  |
        //    |  |     |  |
        //    |  +-----+  |
        //    |           |
        //    #-----------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1),
                        .transitionAction])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = NavigationHSM02(extended)

        // When

        sut.start()

        //    #--------------------#
        //    |                    |
        //    |  +-----+  +-----+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------+-----#
        //    |              v     |
        //    |  +-----+  #-----#  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  #-----#  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------#
        //    |                    |
        //    |  #-----#  +-----+  |
        //    |  | S1  |<-+ S2  |  |
        //    |  |     |  |     |  |
        //    |  #-----#  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1)])

        // When

        extended.reset()
        sut.s1.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------#
        //    |                    |
        //    |  +-----+  #-----#  |
        //    |  | S1  +->| S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  #-----#  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

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

        //    #--------------------#
        //    |              ^     |
        //    |  +-----+  +--+--+  |
        //    |  | S1  |  | S2  |  |
        //    |  |     |  |     |  |
        //    |  +-----+  +-----+  |
        //    |                    |
        //    #--------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction])
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = NavigationHSM03(extended)

        // When

        sut.start()

        //    #--------------------------------------------------#
        //    |                                                  |
        //    |  +--------------------+  +--------------------+  |
        //    |  | S1                 |  | S2                 |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     |  |     |  |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  +--------------------+  +--------------------+  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------+-------------------------------#
        //    |                  |                               |
        //    |  #---------------|----#  +--------------------+  |
        //    |  | S1            |    |  | S2                 |  |
        //    |  |  +-----+  #---v-#  |  |  +-----+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     |  |     |  |  |
        //    |  |  +-----+  #-----#  |  |  +-----+  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  #--------------------#  +--------------------+  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1),
                        .entry(sut.s1.s12)])

        // When

        extended.reset()
        sut.s1.s12.transition(
            to: sut.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------------------#
        //    |                                                  |
        //    |  +--------------------+  #--------------------#  |
        //    |  | S1                 |  | S2                 |  |
        //    |  |  +-----+  +-----+  |  |  #-----#  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     +-------->     |  |     |  |  |
        //    |  |  +-----+  +-----+  |  |  #-----#  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  +--------------------+  #--------------------#  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12),
                        .exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s21)])

        // When

        extended.reset()
        sut.s2.s21.transition(
            to: sut.s2.s22,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------------------#
        //    |                                                  |
        //    |  +--------------------+  #--------------------#  |
        //    |  | S1                 |  | S2                 |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  #-----#  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     +-->     |  |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  #-----#  |  |
        //    |  |                    |  |                    |  |
        //    |  +--------------------+  #--------------------#  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
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
        sut.s2.s22.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------------------#
        //    |                                                  |
        //    |  +--------------------+  #--------------------#  |
        //    |  | S1                 |  | S2            ^    |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  +---+-+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     |  |     |  |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  +--------------------+  #--------------------#  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s22),
                        .transitionAction])

        // When

        extended.reset()
        sut.s2.transition(
            to: sut.s1.s11,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------------------#
        //    |         +-------------------+                    |
        //    |  #------|-------------#  +--+-----------------+  |
        //    |  | S1   v             |  | S2                 |  |
        //    |  |  #-----#  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     |  |     |  |  |
        //    |  |  #-----#  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  #--------------------#  +--------------------+  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1),
                        .entry(sut.s1.s11)])

        // When

        extended.reset()
        sut.s1.s11.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------------------#
        //    |         ^                                        |
        //    |  +------|-------------+  +--------------------+  |
        //    |  | S1   |             |  | S2                 |  |
        //    |  |  +---+-+  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |  |  | S21 |  | S22 |  |  |
        //    |  |  |     |  |     |  |  |  |     |  |     |  |  |
        //    |  |  +-----+  +-----+  |  |  +-----+  +-----+  |  |
        //    |  |                    |  |                    |  |
        //    |  +--------------------+  +--------------------+  |
        //    |                                                  |
        //    #--------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11),
                        .exit(sut.s1),
                        .transitionAction])
    }

    func test_04() {
        // Given

        let extended = Extended()
        let sut = NavigationHSM04(extended)

        // When

        sut.start()

        //    #------------------------------------------------------------------#
        //    |                                                                  |
        //    |  +--------------------+   +-----------------------------------+  |
        //    |  | S1                 |   | S2                                |  |
        //    |  |  +-----+  +-----+  |   |  +--------------------+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21                |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  +-----+  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  +--------------------+   |  |  +-----+  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  +--------------------+  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           +-----------------------------------+  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2.s21.s211,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------------------------+----------------------------#
        //    |                                     |                            |
        //    |  +--------------------+   #---------|-------------------------#  |
        //    |  | S1                 |   | S2      |                         |  |
        //    |  |  +-----+  +-----+  |   |  #------|-------------#  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21  v             |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  #-----#  +-----+  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  +--------------------+   |  |  #-----#  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  #--------------------#  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           #-----------------------------------#  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertTrue(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s211))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s21),
                        .entry(sut.s2.s21.s211)])

        // When

        extended.reset()
        sut.s2.s21.s211.transition(
            to: sut.s2.s21.s212,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |                                                                  |
        //    |  +--------------------+   #-----------------------------------#  |
        //    |  | S1                 |   | S2                                |  |
        //    |  |  +-----+  +-----+  |   |  #--------------------#  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21                |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  #-----#  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     +->|     |  |  |     |  |  |
        //    |  +--------------------+   |  |  +-----+  #-----#  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  #--------------------#  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           #-----------------------------------#  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s211),
                        .transitionAction,
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.s21.s212.transition(
            to: sut.s2.s22,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |                                                                  |
        //    |  +--------------------+   #-----------------------------------#  |
        //    |  | S1                 |   | S2                                |  |
        //    |  |  +-----+  +-----+  |   |  +--------------------+  #-----#  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21                |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  +-----+  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     +---->|     |  |  |
        //    |  +--------------------+   |  |  +-----+  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  +--------------------+  #-----#  |  |
        //    |                           |                                   |  |
        //    |                           #-----------------------------------#  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertTrue(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .exit(sut.s2.s21),
                        .transitionAction,
                        .entry(sut.s2.s22)])

        // When

        extended.reset()
        sut.s2.s22.transition(
            to: sut.s1.s11,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |         +-----------------------------------------------+        |
        //    |  #------|-------------#   +-----------------------------|-----+  |
        //    |  | S1   v             |   | S2                          |     |  |
        //    |  |  #-----#  +-----+  |   |  +--------------------+  +--+--+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21                |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  +-----+  |  |     |  |  |
        //    |  |  #-----#  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  #--------------------#   |  |  +-----+  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  +--------------------+  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           +-----------------------------------+  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s22),
                        .exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1),
                        .entry(sut.s1.s11)])

        // When

        extended.reset()
        sut.s1.s11.transition(
            to: sut.s1.s12,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |                                                                  |
        //    |  #--------------------#   +-----------------------------------+  |
        //    |  | S1                 |   | S2                                |  |
        //    |  |  +-----+  #-----#  |   |  +--------------------+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21                |  | S22 |  |  |
        //    |  |  |     +->|     |  |   |  |  +-----+  +-----+  |  |     |  |  |
        //    |  |  +-----+  #-----#  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  #--------------------#   |  |  +-----+  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  +--------------------+  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           +-----------------------------------+  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11),
                        .transitionAction,
                        .entry(sut.s1.s12)])

        // When

        extended.reset()
        sut.s1.s12.transition(
            to: sut.s2.s21.s212,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |                  +-------------------------+                     |
        //    |  +---------------|----+   #----------------|------------------#  |
        //    |  | S1            |    |   | S2             |                  |  |
        //    |  |  +-----+  +---+-+  |   |  #-------------+------#  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21         |      |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  #-v---#  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  +--------------------+   |  |  +-----+  #-----#  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  #--------------------#  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           #-----------------------------------#  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertTrue(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2.s21.s212))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12),
                        .exit(sut.s1),
                        .transitionAction,
                        .entry(sut.s2),
                        .entry(sut.s2.s21),
                        .entry(sut.s2.s21.s212)])

        // When

        extended.reset()
        sut.s2.s21.s212.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------#
        //    |                                                                  |
        //    |  +--------------------+   #-----------------------------------#  |
        //    |  | S1                 |   | S2              ^                 |  |
        //    |  |  +-----+  +-----+  |   |  +--------------|-----+  +-----+  |  |
        //    |  |  | S11 |  | S12 |  |   |  | S21          |     |  | S22 |  |  |
        //    |  |  |     |  |     |  |   |  |  +-----+  +--+--+  |  |     |  |  |
        //    |  |  +-----+  +-----+  |   |  |  | S211|  | S212|  |  |     |  |  |
        //    |  |                    |   |  |  |     |  |     |  |  |     |  |  |
        //    |  +--------------------+   |  |  +-----+  +-----+  |  |     |  |  |
        //    |                           |  |                    |  |     |  |  |
        //    |                           |  +--------------------+  +-----+  |  |
        //    |                           |                                   |  |
        //    |                           #-----------------------------------#  |
        //    |                                                                  |
        //    #------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)
        XCTAssertFalse(sut.s2.s21.isActive)
        XCTAssertFalse(sut.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s2.s21.s212.isActive)
        XCTAssertFalse(sut.s2.s22.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2.s21.s212),
                        .exit(sut.s2.s21),
                        .transitionAction])
    }
}
