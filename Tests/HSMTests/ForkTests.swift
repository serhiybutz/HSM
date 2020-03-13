//
//  ForkTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class ForkTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = ForkHSM01(extended)

        // When

        sut.start()

        //    #---------------------------#
        //    |       +----+              |
        //    |       | S1 |              |
        //    |       +----+----------+   |
        //    |       | S11           |   |
        //    |       |               |   |
        //    |    +-->               |   |
        //    |    |  |               |   |
        //    |  +-F1 +---------------+   |
        //    |  | |  | S12           |   |
        //    |  | +-->               |   |
        //    |  |    |               |   |
        //    |  |    |               |   |
        //    |  |    +---------------+   |
        //    |  |                        |
        //    |  |    +---------------+   |
        //    |  +----O S2            |   |
        //    |       |               |   |
        //    |       +---------------+   |
        //    #---------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
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

        //    #---------------------------#
        //    |       #----#              |
        //    |       | S1 |              |
        //    |       #----#----------#   |
        //    |       | S11           |   |
        //    |       |               |   |
        //    |    +-->               |   |
        //    |    |  |               |   |
        //    |  +-F1 #---------------#   |
        //    |  | |  | S12           |   |
        //    |  | +-->               |   |
        //    |  |    |               |   |
        //    |  |    |               |   |
        //    |  |    #---------------#   |
        //    |  |                        |
        //    |  |    +---------------+   |
        //    |  +----O S2            |   |
        //    +------>|               |   |
        //    |       +---------------+   |
        //    #---------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11,
                         sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s12)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------#
        //    |       #----#              |
        //    |       | S1 |              |
        //    |       #----#----------#   |
        //    |       | S11           |   |
        //    |       |               |   |
        //    |    +-->               |   |
        //    |    |  |               |   |
        //    |  +-F1 #---------------#   |
        //    |  | |  | S12           |   |
        //    |  | +-->               |   |
        //    |  |    |               |   |
        //    |  |    |               |   |
        //    |  |    #---------------#   |
        //    |  |                        |
        //    |  |    +---------------+   |
        //    |  +----O S2            |   |
        //    +------>|               |   |
        //    |       +---------------+   |
        //    #---------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11,
                         sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11),
                        .exit(sut.s1.s12),
                        .transitionAction,
                        .entry(sut.s2), // | consequent transitions
                        .exit(sut.s2),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s12)])

        // When

        extended.reset()
        sut.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--+------------------------#
        //    |<-+    +----+              |
        //    |       | S1 |              |
        //    |       +----+----------+   |
        //    |       | S11           |   |
        //    |       |               |   |
        //    |    +-->               |   |
        //    |    |  |               |   |
        //    |  +-F1 +---------------+   |
        //    |  | |  | S12           |   |
        //    |  | +-->               |   |
        //    |  |    |               |   |
        //    |  |    |               |   |
        //    |  |    +---------------+   |
        //    |  |                        |
        //    |  |    +---------------+   |
        //    |  +----O S2            |   |
        //    |       |               |   |
        //    |       +---------------+   |
        //    #---------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11),
                        .exit(sut.s1.s12),
                        .transitionAction])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = ForkHSM02(extended)

        // When

        sut.start()

        //    #------------------------------------#
        //    |                                    |
        //    |       +----+                       |
        //    |       | S1 |                       |
        //    |       +----+--------------------+  |
        //    |       | S11                     |  |
        //    |       | +------+   +------+     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | +------+   +------+     |  |
        //    |    |  |                         |  |
        //    |    |  +-------------------------+  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | +-----------+  +------+ |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | +-------+ |  |      | |  |
        //    |  | +------> S1211 | |  +------+ |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | +-------+ |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | +-----------+           |  |
        //    |  |    |                         |  |
        //    |  |    +-------------------------+  |
        //    |  |                                 |
        //    |  |    +------+                     |
        //    |  +----O S2   |                     |
        //    |       |      |                     |
        //    |       +------+                     |
        //    |                                    |
        //    #------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
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

        //    #-------------------------------------#
        //    |                                     |
        //    |        #----#                       |
        //    |        | S1 |                       |
        //    |        #----#--------------------#  |
        //    |        | S11                     |  |
        //    |        | #------#   +------+     |  |
        //    |        | | S111 |   | S112 |     |  |
        //    |     +---->      |   |      |     |  |
        //    |     |  | #------#   +------+     |  |
        //    |     |  |                         |  |
        //    |     |  #-------------------------#  |
        //    |  +->F1 | S12                     |  |
        //    |  |  |  | #-----------#  +------+ |  |
        //    |  |  |  | | S121      |  | S122 | |  |
        //    |  |  |  | | #-------# |  |      | |  |
        //    |  |  +------> S1211 | |  +------+ |  |
        //    |  |     | | |       | |           |  |
        //    |  |     | | #-------# |           |  |
        //    |  |     | |           |           |  |
        //    |  |     | #-----------#           |  |
        //    |  |     |                         |  |
        //    |  |     #-------------------------#  |
        //    |  |                                  |
        //    |  |     +------+                     |
        //    |  +-----O S2   |                     |
        //    +------->|      |                     |
        //    |        +------+                     |
        //    |                                     |
        //    #-------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s121.s1211))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121),
                        .entry(sut.s1.s12.s121.s1211)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------------------------#
        //    |                                     |
        //    |        #----#                       |
        //    |        | S1 |                       |
        //    |        #----#--------------------#  |
        //    |        | S11                     |  |
        //    |        | #------#   +------+     |  |
        //    |        | | S111 |   | S112 |     |  |
        //    |     +---->      |   |      |     |  |
        //    |     |  | #------#   +------+     |  |
        //    |     |  |                         |  |
        //    |     |  #-------------------------#  |
        //    |  +->F1 | S12                     |  |
        //    |  |  |  | #-----------#  +------+ |  |
        //    |  |  |  | | S121      |  | S122 | |  |
        //    |  |  |  | | #-------# |  |      | |  |
        //    |  |  +------> S1211 | |  +------+ |  |
        //    |  |     | | |       | |           |  |
        //    |  |     | | #-------# |           |  |
        //    |  |     | |           |           |  |
        //    |  |     | #-----------#           |  |
        //    |  |     |                         |  |
        //    |  |     #-------------------------#  |
        //    |  |                                  |
        //    |  |     +------+                     |
        //    |  +-----O S2   |                     |
        //    +------->|      |                     |
        //    |        +------+                     |
        //    |                                     |
        //    #-------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s121.s1211))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s121.s1211),
                        .exit(sut.s1.s12.s121),
                        .exit(sut.s1.s12),
                        .transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121),
                        .entry(sut.s1.s12.s121.s1211)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-------------------------------------#
        //    |                                     |
        //    |        #----#                       |
        //    |        | S1 |                       |
        //    |        #----#--------------------#  |
        //    |        | S11                     |  |
        //    |        | #------#   +------+     |  |
        //    |        | | S111 |   | S112 |     |  |
        //    |     +---->      |   |      |     |  |
        //    |     |  | #------#   +------+     |  |
        //    |     |  |                         |  |
        //    |     |  #-------------------------#  |
        //    |  +->F1 | S12                     |  |
        //    |  |  |  | +-----------+  #------# |  |
        //    |  |  |  | | S121      |  | S122 | |  |
        //    |  |  |  | | +-------+ |  |      | |  |
        //    |  |  +------> S1211 | |  #------# |  |
        //    |  |     | | |       | |      ^    |  |
        //    |  |     | | +-------+ |      +-------+
        //    |  |     | |           |           |  |
        //    |  |     | +-----------+           |  |
        //    |  |     |                         |  |
        //    |  |     #-------------------------#  |
        //    |  |                                  |
        //    |  |     +------+                     |
        //    |  +-----O S2   |                     |
        //    |        |      |                     |
        //    |        +------+                     |
        //    |                                     |
        //    #-------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s122))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12.s121.s1211),
                        .exit(sut.s1.s12.s121),
                        .transitionAction,
                        .entry(sut.s1.s12.s122)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s11.s112,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------+------------#
        //    |                        |            |
        //    |        #----#          |            |
        //    |        | S1 |          |            |
        //    |        #----#----------|---------#  |
        //    |        | S11           v         |  |
        //    |        | +------+   #------#     |  |
        //    |        | | S111 |   | S112 |     |  |
        //    |     +---->      |   |      |     |  |
        //    |     |  | +------+   #------#     |  |
        //    |     |  |                         |  |
        //    |     |  #-------------------------#  |
        //    |  +->F1 | S12                     |  |
        //    |  |  |  | +-----------+  #------# |  |
        //    |  |  |  | | S121      |  | S122 | |  |
        //    |  |  |  | | +-------+ |  |      | |  |
        //    |  |  +------> S1211 | |  #------# |  |
        //    |  |     | | |       | |           |  |
        //    |  |     | | +-------+ |           |  |
        //    |  |     | |           |           |  |
        //    |  |     | +-----------+           |  |
        //    |  |     |                         |  |
        //    |  |     #-------------------------#  |
        //    |  |                                  |
        //    |  |     +------+                     |
        //    |  +-----O S2   |                     |
        //    |        |      |                     |
        //    |        +------+                     |
        //    |                                     |
        //    #-------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s122))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111),
                        .transitionAction,
                        .entry(sut.s1.s11.s112)])
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = ForkHSM03(extended)

        // When

        sut.start()

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       +----+                                                  |
        //    |       | S1 |                                                  |
        //    |       +----+-----------------------------------------------+  |
        //    |       | S11 H*                                             |  |
        //    |       |   +--------------------------+   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   +-------+   +-v-----+  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   +-------+   +-------+  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   +--------------------------+                     |  |
        //    |    |  |                                                    |  |
        //    |    |  +----------------------------------------------------+  |
        //    |  +-F1 | S12 H*                                             |  |
        //    |  | |  |   +-----------------------------------+  +------+  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   +----------------------------+  |  |      |  |  |
        //    |  | +----------> S1211 H                    |  |  +------+  |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   +----------------------------+  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   +-----------------------------------+            |  |
        //    |  |    |                                                    |  |
        //    |  |    +----------------------------------------------------+  |
        //    |  |    | S13                                                |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |   | S131  |                                        |  |
        //    |  |    |   |       |                                        |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |                                                    |  |
        //    |  |    +----------------------------------------------------+  |
        //    |  |    +------+                                                |
        //    |  +----O S2   |                                                |
        //    |       |      |                                                |
        //    |       +------+                                                |
        //    #---------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
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

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    |       |   #--------------------------#   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   +-------+   #-v-----#  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   +-------+   #-------#  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   #--------------------------#                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    |  +-F1 | S12 H*                                             |  |
        //    |  | |  |   #-----------------------------------#  +------+  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   #----------------------------#  |  |      |  |  |
        //    |  | +----------> S1211 H                    |  |  +------+  |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   #----------------------------#  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   #-----------------------------------#            |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    | S13                                                |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |   | S131  |                                        |  |
        //    |  |    |   |       |                                        |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    +------+                                                |
        //    |  +----O S2   |                                                |
        //    +------>|      |                                                |
        //    |       +------+                                                |
        //    #---------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1112,
                         sut.s1.s12.s121.s1211,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111),
                        .entry(sut.s1.s11.s111.s1112),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121),
                        .entry(sut.s1.s12.s121.s1211)])

        // When

        extended.reset()
        sut.s1.s11.s111.s1112.transition(
            to: sut.s1.s11.s111.s1111,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    |       |   #--------------------------#   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   #-------#   +-v-----+  |   |      |          |  |
        //    |       |   |   | S1111 |<--+ S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   #-------#   +-------+  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   #--------------------------#                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1111.isActive) // target
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1111,
                         sut.s1.s12.s121.s1211,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111.s1112),
                        .transitionAction,
                        .entry(sut.s1.s11.s111.s1111)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s11,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    +------>|   #--------------------------#   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   #-------#   +-v-----+  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   #-------#   +-------+  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   #--------------------------#                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive) // target
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1111,
                         sut.s1.s12.s121.s1211,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])

        // When

        extended.reset()
        sut.s1.s12.s121.s1211.transition(
            to: sut.s1.s12.s121.s1211.s12112,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |    |  #----------------------------------------------------#  |
        //    |  +-F1 | S12 H*                                             |  |
        //    |  | |  |   #-----------------------------------#  +------+  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   #--------------------+-------#  |  |      |  |  |
        //    |  | +----------> S1211 H            v       |  |  +------+  |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   #----------------------------#  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   #-----------------------------------#            |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.s12112.isActive) // target
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1111,
                         sut.s1.s12.s121.s1211.s12112,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1.s12.s121.s1211.s12112)])

        // When

        extended.reset()
        sut.s1.s13.transition(
            to: sut.s1.s13.s131,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |  |    #----------------------------------------------------#  |
        //    |  |    | S13                                                |  |
        //    |  |    |   #-------#                                        |  |
        //    |  |    +-->| S131  |                                        |  |
        //    |  |    |   |       |                                        |  |
        //    |  |    |   #-------#                                        |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertTrue(sut.s1.s13.s131.isActive) // target
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1111,
                         sut.s1.s12.s121.s1211.s12112,
                         sut.s1.s13.s131))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1.s13.s131)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    |       |   #--------------------------#   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   +-------+   #-v-----#  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   +-------+   #-------#  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   #--------------------------#                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    |  +-F1 | S12 H*                                             |  |
        //    |  | |  |   #-----------------------------------#  +------+  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   #----------------------------#  |  |      |  |  |
        //    |  | +----------> S1211 H                    |  |  +------+  |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   #----------------------------#  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   #-----------------------------------#            |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    | S13                                                |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |   | S131  |                                        |  |
        //    |  |    |   |       |                                        |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    +------+                                                |
        //    |  +----O S2   |                                                |
        //    +------>|      |                                                |
        //    |       +------+                                                |
        //    #---------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive) // target

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1112,
                         sut.s1.s12.s121.s1211.s12112,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111.s1111),
                        .exit(sut.s1.s11.s111),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s121.s1211.s12112),
                        .exit(sut.s1.s12.s121.s1211),
                        .exit(sut.s1.s12.s121),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13.s131),
                        .exit(sut.s1.s13),
                        .transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111),
                        .entry(sut.s1.s11.s111.s1112),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121),
                        .entry(sut.s1.s12.s121.s1211),
                        .entry(sut.s1.s12.s121.s1211.s12112)])

        // When

        extended.reset()
        sut.s1.s11.s111.transition(
            to: sut.s1.s11.s112,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    |       |   +--------------------------+   #------#          |  |
        //    |       |   | S111            *        +-->| S112 |          |  |
        //    |       |   |   +-------+   +-v-----+  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   #------#          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   +-------+   +-------+  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   +--------------------------+                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // target
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s121.s1211.s12112,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111.s1112),
                        .exit(sut.s1.s11.s111),
                        .transitionAction,
                        .entry(sut.s1.s11.s112)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |    |  #----------------------------------------------+-----#  |
        //    |  +-F1 | S12 H*                                       v     |  |
        //    |  | |  |   +-----------------------------------+  #------#  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   +----------------------------+  |  |      |  |  |
        //    |  | +----------> S1211 H                    |  |  #------#  |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   +--------+  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   +----------------------------+  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   +-----------------------------------+            |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1112.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive) // target
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s122,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12.s121.s1211.s12112),
                        .exit(sut.s1.s12.s121.s1211),
                        .exit(sut.s1.s12.s121),
                        .transitionAction,
                        .entry(sut.s1.s12.s122)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #---------------------------------------------------------------#
        //    |                                                               |
        //    |       #----#                                                  |
        //    |       | S1 |                                                  |
        //    |       #----#-----------------------------------------------#  |
        //    |       | S11 H*                                             |  |
        //    |       |   #--------------------------#   +------+          |  |
        //    |       |   | S111            *        |   | S112 |          |  |
        //    |       |   |   +-------+   #-v-----#  |   |      |          |  |
        //    |       |   |   | S1111 |   | S1112 |  |   +------+          |  |
        //    |       |   |   |       |   |       |  |                     |  |
        //    |    +------>   +-------+   #-------#  |                     |  |
        //    |    |  |   |                          |                     |  |
        //    |    |  |   #--------------------------#                     |  |
        //    |    |  |                                                    |  |
        //    |    |  #----------------------------------------------------#  |
        //    |  +-F1 | S12 H*                                             |  |
        //    |  | |  |   #-----------------------------------#  +------+  |  |
        //    |  | |  |   | S121                              |  | S122 |  |  |
        //    |  | |  |   |   #----------------------------#  |  |      |  |  |
        //    |  | +----------> S1211 H                    |  |  +------+  |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |   | S12111 |   | S12112 |  |  |            |  |
        //    |  |    |   |   |   |        |   |        |  |  |            |  |
        //    |  |    |   |   |   +--------+   #--------#  |  |            |  |
        //    |  |    |   |   |                            |  |            |  |
        //    |  |    |   |   #----------------------------#  |            |  |
        //    |  |    |   |                                   |            |  |
        //    |  |    |   #-----------------------------------#            |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    | S13                                                |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |   | S131  |                                        |  |
        //    |  |    |   |       |                                        |  |
        //    |  |    |   +-------+                                        |  |
        //    |  |    |                                                    |  |
        //    |  |    #----------------------------------------------------#  |
        //    |  |    +------+                                                |
        //    |  +----O S2   |                                                |
        //    +------>|      |                                                |
        //    |       +------+                                                |
        //    #---------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s1.s11.s111.s1112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s121.s1211.s12111.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.s12112.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive) // target

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111.s1112,
                         sut.s1.s12.s121.s1211.s12112,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s122),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13),
                        .transitionAction,
                        .entry(sut.s2),
                        .exit(sut.s2),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111),
                        .entry(sut.s1.s11.s111.s1112),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121),
                        .entry(sut.s1.s12.s121.s1211),
                        .entry(sut.s1.s12.s121.s1211.s12112)])
    }
}
