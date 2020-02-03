//
//  OrthogonalTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class OrthogonalTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = OrthogonalHSM01(extended)

        // When

        sut.start()

        //    #----------------#
        //    |                |
        //    |  +----+        |
        //    |  | S0 |        |
        //    |  +----+-----+  |
        //    |  | S1       |  |
        //    |  |          |  |
        //    |  +----------+  |
        //    |  | S2       |  |
        //    |  |          |  |
        //    |  +----------+  |
        //    |                |
        //    #----------------#

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

        //    #----------------#
        //    |                |
        //    |  #----#        |
        //    +->| S0 |        |
        //    |  #----#-----#  |
        //    |  | S1       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    |  | S2       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    |                |
        //    #----------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s2)])

        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------#
        //    |                |
        //    |  +----+        |
        //    |  | S0 |        |
        //    |  +----+-----+  |
        //    |<-+ S1       |  |
        //    |  |          |  |
        //    |  +----------+  |
        //    |  | S2       |  |
        //    |  |          |  |
        //    |  +----------+  |
        //    |                |
        //    #----------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .exit(sut.s0.s2),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------#
        //    |                |
        //    |  #----#        |
        //    |  | S0 |        |
        //    |  #----#-----#  |
        //    +->| S1       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    |  | S2       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    |                |
        //    #----------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s1)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------#
        //    |                |
        //    |  #----#        |
        //    |  | S0 |        |
        //    |  #----#-----#  |
        //    |  | S1       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    +->| S2       |  |
        //    |  |          |  |
        //    |  #----------#  |
        //    |                |
        //    #----------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])
    }

    func test_02() {
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

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1.s11,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

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

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s1.s11)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s2.s21,
            action: { extended.transitionSequence.append(.transitionAction) }
        )


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

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2.s21)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    |   | S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    +-->|   +---------+   |   |
        //    |   |   | S11     |   |   |
        //    |   |   |         |   |   |
        //    |   |   +---------+   |   |
        //    |   |                 |   |
        //    |   #-----------------#   |
        //    |   | S2              |   |
        //    |   |   #---------#   |   |
        //    |   |   | S21     |   |   |
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
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertTrue(sut.s0.s2.s21.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1.s11),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--+----------------------#
        //    |<-+                      |
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

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1),
                        .exit(sut.s0.s2.s21),
                        .exit(sut.s0.s2),
                        .transitionAction])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------------#
        //    |                         |
        //    |   #----#                |
        //    |   | S0 |                |
        //    |   #----#------------#   |
        //    |   | S1              |   |
        //    +-->|   +---------+   |   |
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

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s1)])
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = OrthogonalHSM03(extended)

        // When

        sut.start()

        //    #-----------------------------------------------#
        //    |                                               |
        //    |   +----+                                      |
        //    |   | S0 |                                      |
        //    |   +----+----------------------------------+   |
        //    |   | S1                                    |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |   | S11     |   | S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |   | S2                                    |   |
        //    |   |   +-----------------+   +---------+   |   |
        //    |   |   | S21             |   | S22     |   |   |
        //    |   |   |   +---------+   |   |         |   |   |
        //    |   |   |   | S211    |   |   +---------+   |   |
        //    |   |   |   |         |   |                 |   |
        //    |   |   |   +---------+   |                 |   |
        //    |   |   |                 |                 |   |
        //    |   |   +-----------------+                 |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |   | S3                                    |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |                                               |
        //    |   +---------+                                 |
        //    |   | S4      |                                 |
        //    |   |         |                                 |
        //    |   +---------+                                 |
        //    |                                               |
        //    #-----------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s2.s21.s211,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------#
        //    |                                               |
        //    |   #----#                                      |
        //    |   | S0 |                                      |
        //    |   #----#----------------------------------#   |
        //    |   | S1                                    |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |   | S11     |   | S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    |   | S2                                    |   |
        //    |   |   #-----------------#   +---------+   |   |
        //    |   |   | S21             |   | S22     |   |   |
        //    |   |   |   #---------#   |   |         |   |   |
        //    +---------->| S211    |   |   +---------+   |   |
        //    |   |   |   |         |   |                 |   |
        //    |   |   |   #---------#   |                 |   |
        //    |   |   |                 |                 |   |
        //    |   |   #-----------------#                 |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    |   | S3                                    |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    |                                               |
        //    |   +---------+                                 |
        //    |   | S4      |                                 |
        //    |   |         |                                 |
        //    |   +---------+                                 |
        //    |                                               |
        //    #-----------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertTrue(sut.s0.s2.s21.isActive)
        XCTAssertTrue(sut.s0.s2.s21.s211.isActive) // target
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertTrue(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s3),
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s2.s21),
                        .entry(sut.s0.s2.s21.s211)])

        // When

        extended.reset()
        sut.s0.s2.s21.transition(
            to: sut.s0.s2.s22,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |   #---------------------------------------#   |
        //    |   | S2                                    |   |
        //    |   |   +-----------------+   #---------#   |   |
        //    |   |   | S21             +-->| S22     |   |   |
        //    |   |   |   +---------+   |   |         |   |   |
        //    |   |   |   | S211    |   |   #---------#   |   |
        //    |   |   |   |         |   |                 |   |
        //    |   |   |   +---------+   |                 |   |
        //    |   |   |                 |                 |   |
        //    |   |   +-----------------+                 |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s0.s2.s22.isActive) // target
        XCTAssertTrue(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s2.s21.s211),
                        .exit(sut.s0.s2.s21),
                        .transitionAction,
                        .entry(sut.s0.s2.s22)])

        // When

        extended.reset()
        sut.s0.s1.transition(
            to: sut.s0.s1.s11,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------#
        //    |                                               |
        //    |   #----#                                      |
        //    |   | S0 |                                      |
        //    |   #----#----------------------------------#   |
        //    |   | S1                                    |   |
        //    |   |   #---------#   +---------+           |   |
        //    +------>| S11     |   | S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   #---------#   +---------+           |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive) // target
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s0.s2.s22.isActive)
        XCTAssertTrue(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s1.s11)])

        // When

        extended.reset()
        sut.s0.s1.s11.transition(
            to: sut.s0.s1.s12,
            action: { extended.transitionSequence.append(.transitionAction) }
        )


        //    #-----------------------------------------------#
        //    |                                               |
        //    |   #----#                                      |
        //    |   | S0 |                                      |
        //    |   #----#----------------------------------#   |
        //    |   | S1                                    |   |
        //    |   |   +---------+   #---------#           |   |
        //    |   |   | S11     +-->| S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   +---------+   #---------#           |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s1.s12.isActive) // target
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertTrue(sut.s0.s2.s22.isActive)
        XCTAssertTrue(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1.s11),
                        .transitionAction,
                        .entry(sut.s0.s1.s12)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s4,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------#
        //    |                                               |
        //    |   +----+                                      |
        //    |   | S0 |                                      |
        //    |   +----+----------------------------------+   |
        //    |   | S1                                    |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |   | S11     |   | S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |   | S2                                    |   |
        //    |   |   +-----------------+   +---------+   |   |
        //    |   |   | S21             |   | S22     |   |   |
        //    |   |   |   +---------+   |   |         |   |   |
        //    |   |   |   | S211    |   |   +---------+   |   |
        //    |   |   |   |         |   |                 |   |
        //    |   |   |   +---------+   |                 |   |
        //    |   |   |                 |                 |   |
        //    |   |   +-----------------+                 |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |   | S3                                    |   |
        //    |   |                                       |   |
        //    |   +---------------------------------------+   |
        //    |                                               |
        //    |   #---------#                                 |
        //    +-->| S4      |                                 |
        //    |   |         |                                 |
        //    |   #---------#                                 |
        //    |                                               |
        //    #-----------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s0.s3.isActive)
        XCTAssertTrue(sut.s4.isActive) // target

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1.s12),
                        .exit(sut.s0.s1),
                        .exit(sut.s0.s2.s22),
                        .exit(sut.s0.s2),
                        .exit(sut.s0.s3),
                        .transitionAction,
                        .entry(sut.s4)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s3,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------#
        //    |                                               |
        //    |   #----#                                      |
        //    |   | S0 |                                      |
        //    |   #----#----------------------------------#   |
        //    |   | S1                                    |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |   | S11     |   | S12     |           |   |
        //    |   |   |         |   |         |           |   |
        //    |   |   +---------+   +---------+           |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    |   | S2                                    |   |
        //    |   |   +-----------------+   +---------+   |   |
        //    |   |   | S21             |   | S22     |   |   |
        //    |   |   |   +---------+   |   |         |   |   |
        //    |   |   |   | S211    |   |   +---------+   |   |
        //    |   |   |   |         |   |                 |   |
        //    |   |   |   +---------+   |                 |   |
        //    |   |   |                 |                 |   |
        //    |   |   +-----------------+                 |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    +-->| S3                                    |   |
        //    |   |                                       |   |
        //    |   #---------------------------------------#   |
        //    |                                               |
        //    |   +---------+                                 |
        //    |   | S4      |                                 |
        //    |   |         |                                 |
        //    |   +---------+                                 |
        //    |                                               |
        //    #-----------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s12.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s21.s211.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertTrue(sut.s0.s3.isActive)
        XCTAssertFalse(sut.s4.isActive) // target

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s4),
                        .transitionAction,
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s3)])
    }

    func test_04() {
        // Given

        let extended = Extended()
        let sut = OrthogonalHSM04(extended)

        // When

        sut.start()

        //    #-----------------------------------------------------------------#
        //    |                                                                 |
        //    |   +----+                                                        |
        //    |   | S0 |                                                        |
        //    |   +----+----------------------------------------------------+   |
        //    |   | S1   *                                                  |   |
        //    |   |   +--v--+                                               |   |
        //    |   |   | S11 |                                               |   |
        //    |   |   +-----+-----------+-------------------------------+   |   |
        //    |   |   | S111            | S112                          |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   +-----------------+-------------------------------+   |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |                                                                 |
        //    |   +---------+                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   +---------+                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s1.s11.s112.s1122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------------------------#
        //    +-----------------------------------------------+                 |
        //    |   #----#                                      |                 |
        //    |   | S0 |                                      |                 |
        //    |   #----#--------------------------------------|-------------#   |
        //    |   | S1   *                                    |             |   |
        //    |   |   #--v--#                                 |             |   |
        //    |   |   | S11 |                                 |             |   |
        //    |   |   #-----#-----------#---------------------|---------#   |   |
        //    |   |   | S111            | S112                v         |   |   |
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |                                                                 |
        //    |   +---------+                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   +---------+                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2),
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s1.s11.s111),
                        .entry(sut.s0.s1.s11.s112),
                        .entry(sut.s0.s1.s11.s112.s1122)])

        // When

        extended.reset()
        sut.s0.s1.s11.s112.s1121.transition(
            to: sut.s0.s1.s11.s112.s1121,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------------------------#
        //    |                                                                 |
        //    |   #----#                                                        |
        //    |   | S0 |                                                        |
        //    |   #----#----------------------------------------------------#   |
        //    |   | S1   *                                                  |   |
        //    |   |   #--v--#                                               |   |
        //    |   |   | S11 |                                               |   |
        //    |   |   #-----#-----------#-------------------------------#   |   |
        //    |   |   | S111            | S112                          |   |   |
        //    |   |   |   +---------+   |   #---------#   +---------+   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |<--+ S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   #---------#   +---------+   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |                                                                 |
        //    |   +---------+                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   +---------+                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.s1121.isActive) // target
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1.s11.s112.s1122),
                        .transitionAction,
                        .entry(sut.s0.s1.s11.s112.s1121)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0.s2.s22,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------------------------#
        //    |                                                                 |
        //    |   #----#                                                        |
        //    |   | S0 |                                                        |
        //    |   #----#----------------------------------------------------#   |
        //    |   | S1   *                                                  |   |
        //    |   |   #--v--#                                               |   |
        //    |   |   | S11 |                                               |   |
        //    |   |   #-----#-----------#-------------------------------#   |   |
        //    |   |   | S111            | S112                          |   |   |
        //    |   |   |   +---------+   |   #---------#   +---------+   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   #---------#   +---------+   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   #--------#                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   #--------#                               |   |
        //    |   |                    ^                                    |   |
        //    |   #--------------------|------------------------------------#   |
        //    +------------------------+                                        |
        //    |   +---------+                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   +---------+                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive)
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertTrue(sut.s0.s2.s22.isActive) // target
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s0.s2.s22)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s3,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------------------------#
        //    |                                                                 |
        //    |   +----+                                                        |
        //    |   | S0 |                                                        |
        //    |   +----+----------------------------------------------------+   |
        //    |   | S1  *                                                   |   |
        //    |   |   +-v---+                                               |   |
        //    |   |   | S11 |                                               |   |
        //    |   |   +-----+-----------+-------------------------------+   |   |
        //    |   |   | S111            | S112                          |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   +-----------------+-------------------------------+   |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |                                                                 |
        //    |   #---------#                                                   |
        //    +-->| S3      |                                                   |
        //    |   |         |                                                   |
        //    |   #---------#                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s0.isActive)
        XCTAssertFalse(sut.s0.s1.isActive)
        XCTAssertFalse(sut.s0.s1.s11.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertFalse(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertTrue(sut.s3.isActive) // target

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s0.s1.s11.s111),
                        .exit(sut.s0.s1.s11.s112.s1121),
                        .exit(sut.s0.s1.s11.s112),
                        .exit(sut.s0.s1),
                        .exit(sut.s0.s2.s22),
                        .exit(sut.s0.s2),
                        .transitionAction,
                        .entry(sut.s3)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s0,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------------------------------------------------------#
        //    |                                                                 |
        //    |   #----#                                                        |
        //    +-->| S0 |                                                        |
        //    |   #----#----------------------------------------------------#   |
        //    |   | S1  *                                                   |   |
        //    |   |   #-v---#                                               |   |
        //    |   |   | S11 |                                               |   |
        //    |   |   #-----#-----------#-------------------------------#   |   |
        //    |   |   | S111            | S112                          |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   +---------+   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   +--------+                               |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |                                                                 |
        //    |   +---------+                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   +---------+                                                   |
        //    |                                                                 |
        //    #-----------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s0.isActive) // target
        XCTAssertTrue(sut.s0.s1.isActive)
        XCTAssertTrue(sut.s0.s1.s11.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s3),
                        .transitionAction,
                        .entry(sut.s0.s1),
                        .entry(sut.s0.s1.s11.s111),
                        .entry(sut.s0.s1.s11.s112),
                        .entry(sut.s0.s2)])
    }
}
