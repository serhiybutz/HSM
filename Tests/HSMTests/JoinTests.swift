//
//  JoinTests.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class JoinTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = JoinHSM01(extended)

        // When

        sut.start()

        //    #----------------------#
        //    |       +----+         |
        //    |       | S1 |         |
        //    |       +----+-----+   |
        //    |       | S11      |   |
        //    |    +--O          |   |
        //    |    |  |          |   |
        //    |  +-J1 +----------+   |
        //    |  | |  | S12      |   |
        //    |  | +--O          |   |
        //    |  |    |          |   |
        //    |  |    +----------+   |
        //    |  |                   |
        //    |  |    +----------+   |
        //    |  +----> S2       |   |
        //    |       |          |   |
        //    |       +----------+   |
        //    #----------------------#

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
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------------#
        //    |       #----#         |
        //    +------>| S1 |         |
        //    |       #----#-----#   |
        //    |       | S11      |   |
        //    |    +--O          |   |
        //    |    |  |          |   |
        //    |  +-J1 #----------#   |
        //    |  | |  | S12      |   |
        //    |  | +--O          |   |
        //    |  |    |          |   |
        //    |  |    #----------#   |
        //    |  |                   |
        //    |  |    #----------#   |
        //    |  +----> S2       |   |
        //    |       |          |   |
        //    |       #----------#   |
        //    #----------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s12),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------------#
        //    |       +----+         |
        //    |       | S1 |         |
        //    |       +----+-----+   |
        //    |       | S11      |   |
        //    |    +--O          |   |
        //    |    |  |          |   |
        //    |  +-J1 +----------+   |
        //    |  | |  | S12      |   |
        //    |  | +--O          |   |
        //    +------>|          |   |
        //    |  |    +----------+   |
        //    |  |                   |
        //    |  |    #----------#   |
        //    |  |    | S2       |   |
        //    |  +---->          |   |
        //    |       #----------#   |
        //    #----------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s12),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12),
                        .entry(sut.s2)])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = JoinHSM02(extended)

        // When

        sut.start()

        //    #--------------------------------------#
        //    |       +----+                         |
        //    |       | S1 |                         |
        //    |       +----+---------------------+   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   +-v-----+  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   +-------+  |   |
        //    |    |  |                          |   |
        //    |  +-J1 +--------------------------+   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    +--------------------------+   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

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

        //    #--------------------------------------#
        //    |       #----#                         |
        //    +------>| S1 |                         |
        //    |       #----#---------------------#   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   #-v-----#  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   #-------#  |   |
        //    |    |  |                          |   |
        //    |  +-J1 #--------------------------#   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    #--------------------------#   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s12)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s11.s112, // external self-transition
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #----------------------------+---------#
        //    |       #----#               |         |
        //    |       | S1 |               |         |
        //    |       #----#---------------|-----#   |
        //    |       | S11             *  v     |   |
        //    |       |   +-------+   #-v-----#  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   #-------#  |   |
        //    |    |  |                          |   |
        //    |  +-J1 #--------------------------#   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    #--------------------------#   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112),
                        .transitionAction,
                        .entry(sut.s1.s11.s112)])

        // When

        extended.reset()
        sut.s1.s12.transition(
            to: sut.s1.s12.s121,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------#
        //    |       #----#                         |
        //    |       | S1 |                         |
        //    |       #----#---------------------#   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   #-v-----#  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   #-------#  |   |
        //    |    |  |                          |   |
        //    |  +-J1 #--------+-----------------#   |
        //    |  | |  | S12 H  v                 |   |
        //    |  | |  |   #-------#   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   #-------#   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    #--------------------------#   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s121))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction,
                        .entry(sut.s1.s12.s121)])

        // When

        extended.reset()
        sut.s1.s11.s112.transition(
            to: sut.s1.s11.s111,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------#
        //    |       +----+                         |
        //    |       | S1 |                         |
        //    |       +----+---------------------+   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   +-v-----+  |   |
        //    |       |   | S111  |<--+ S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   +-------+  |   |
        //    |    |  |                          |   |
        //    |  +-J1 +--------------------------+   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    +--------------------------+   |
        //    |  |                                   |
        //    |  |    #--------------------------#   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       #--------------------------#   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112),
                        .transitionAction,
                        .entry(sut.s1.s11.s111),
                        .exit(sut.s1.s11.s111),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s121),
                        .exit(sut.s1.s12),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------#
        //    |       #----#                         |
        //    +------>| S1 |                         |
        //    |       #----#---------------------#   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   #-v-----#  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   #-------#  |   |
        //    |    |  |                          |   |
        //    |  +-J1 #--------------------------#   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   #-------#   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   #-------#   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    #--------------------------#   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive) // in history
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s121))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s121)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------#
        //    |       +----+                         |
        //    |       | S1 |                         |
        //    |       +----+---------------------+   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   #-v-----#  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   #-------#  |   |
        //    |    |  |                          |   |
        //    |  +-J1 +--------------------------+   |
        //    |  | |  | S12 H            v==     |   |
        //    |  | |  |   +-------+   #-------#  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   #-------#  |   |
        //    |  |    |                          |   |
        //    |  |    +--------------------------+   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s122))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12.s121),
                        .transitionAction,
                        .entry(sut.s1.s12.s122)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #--------------------------------------#
        //    |       +----+                         |
        //    |       | S1 |                         |
        //    |       +----+---------------------+   |
        //    |       | S11             *        |   |
        //    |       |   +-------+   +-v-----+  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   +-------+   +-------+  |   |
        //    |    |  |                          |   |
        //    |  +-J1 +--------------------------+   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    +--------------------------+   |
        //    |  |                                   |
        //    |  |    #--------------------------#   |
        //    |  +----> S2                       |   |
        //    +------>|                          |   |
        //    |       #--------------------------#   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s122),
                        .exit(sut.s1.s12),
                        .transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s11.s111,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #-----------------+--------------------#
        //    |       +----+    |                    |
        //    |       | S1 |    |                    |
        //    |       +----+----|----------------+   |
        //    |       | S11     v       *        |   |
        //    |       |   #-------#   +-v-----+  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   #-------#   +-------+  |   |
        //    |    |  |                          |   |
        //    |  +-J1 +--------------------------+   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   +-------+   #-------#  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   +-------+   #-------#  |   |
        //    |  |    |                          |   |
        //    |  |    +--------------------------+   |
        //    |  |                                   |
        //    |  |    +--------------------------+   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       +--------------------------+   |
        //    #--------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive) // in history
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s122))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s122),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111)])
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = JoinHSM03(extended)

        // When

        sut.start()

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       #-v--#                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       #----#--------------------------------------------------------------------------------#  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   #-v----------------------------------------------------------------#  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               #-v-----#                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   #-------#--------#------------------------------#  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   #-v-------#  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   #---------#  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   #----------------#------------------------------#  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   #------------------------------------------------------------------#  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   +--------+                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   +--------+                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    +----------------------------+                                                           |
        //    |  +----> S2                         |                                                           |
        //    |       |                            |                                                           |
        //    |       +----------------------------+                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1122.s11221,
                         sut.s1.s11.s112.s1122.s11222.s112222,
                         sut.s1.s12,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.entry(sut),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s11.s112.s1122.s11221),
                        .entry(sut.s1.s11.s112.s1122.s11222),
                        .entry(sut.s1.s11.s112.s1122.s11222.s112222),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s13)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s2,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       +-v--+                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       +----+--------------------------------------------------------------------------------+  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   +-v----------------------------------------------------------------+  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               +-v-----+                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   +----------------+------------------------------+  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   +------------------------------------------------------------------+  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 +-------------------------------------------------------------------------------------+  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   +--------+                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   +--------+                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    #----------------------------#                                                           |
        //    |  +----> S2                         |                                                           |
        //    +------>|                            |                                                           |
        //    |       #----------------------------#                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive) // initial
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112.s1122.s11221),
                        .exit(sut.s1.s11.s112.s1122.s11222.s112222),
                        .exit(sut.s1.s11.s112.s1122.s11222),
                        .exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13),
                        .transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       #-v--#                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       #----#--------------------------------------------------------------------------------#  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   #-v----------------------------------------------------------------#  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               #-v-----#                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   #-------#--------#------------------------------#  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   #-v-------#  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   #---------#  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   #----------------#------------------------------#  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   #------------------------------------------------------------------#  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   #--------#                                                           |  |
        //    |  | +------O S121   |   | S122   |<-------------------------------------------------------------+
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   #--------#                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    +----------------------------+                                                           |
        //    |  +----> S2                         |                                                           |
        //    |       |                            |                                                           |
        //    |       +----------------------------+                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive) // target
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1122.s11221,
                         sut.s1.s11.s112.s1122.s11222.s112222,
                         sut.s1.s12.s122,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s11.s112.s1122.s11221),
                        .entry(sut.s1.s11.s112.s1122.s11222),
                        .entry(sut.s1.s11.s112.s1122.s11222.s112222),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s122)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s13.s131,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   #--------#                                                                        |  |
        //    =---------->| S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   #--------#                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertTrue(sut.s1.s13.s131.isActive) // target
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1122.s11221,
                         sut.s1.s11.s112.s1122.s11222.s112222,
                         sut.s1.s12.s122,
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

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       +-v--+                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       +----+--------------------------------------------------------------------------------+  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   +-v----------------------------------------------------------------+  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               +-v-----+                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   +----------------+------------------------------+  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   +------------------------------------------------------------------+  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 +-------------------------------------------------------------------------------------+  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   +--------+                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   +--------+                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    #----------------------------#                                                           |
        //    |  +----> S2                         |                                                           |
        //    +------>|                            |                                                           |
        //    |       #----------------------------#                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive) // initial
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertTrue(sut.s2.isActive) // target

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112.s1122.s11221),
                        .exit(sut.s1.s11.s112.s1122.s11222.s112222),
                        .exit(sut.s1.s11.s112.s1122.s11222),
                        .exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s122),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13.s131),
                        .exit(sut.s1.s13),
                        .transitionAction,
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s11.s111,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       #-v--#                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       #----#--------------------------------------------------------------------------------#  |
        //    |       | S11             *                                                                   |  |
        //    |       |   #-------#   +-v----------------------------------------------------------------+  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               +-v-----+                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    +---------->|       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   +----------------+------------------------------+  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   #-------#   +------------------------------------------------------------------+  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   #--------#                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   #--------#                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    |  |    +----------------------------+                                                           |
        //    |  +----> S2                         |                                                           |
        //    |       |                            |                                                           |
        //    |       +----------------------------+                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive) // target
        XCTAssertFalse(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive) // target
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s122,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s122),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s111)])

        // When

        extended.reset()
        sut.s1.s12.transition(
            to: sut.s1.s12.s121,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   #--------#   +--------+                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    +-->|        |   |        |                                                           |  |
        //    |  |    |   #--------#   +--------+                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive) // target
        XCTAssertFalse(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive) // target
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12.s121,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12.s122),
                        .transitionAction,
                        .entry(sut.s1.s12.s121)])

        // When

        extended.reset()
        sut.s1.s11.s111.transition(
            to: sut.s1.s11.s112,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       #-v--#                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       #----#--------------------------------------------------------------------------------#  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   #-v----------------------------------------------------------------#  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               #-v-----#                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       +-->|   +-------+   #-------#--------#------------------------------#  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   #-v-------#  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   #---------#  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   #----------------#------------------------------#  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   #------------------------------------------------------------------#  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial  // target
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1122.s11221,
                         sut.s1.s11.s112.s1122.s11222.s112222,
                         sut.s1.s12.s121,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s111),
                        .transitionAction,
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s11.s112.s1122.s11221),
                        .entry(sut.s1.s11.s112.s1122.s11222),
                        .entry(sut.s1.s11.s112.s1122.s11222.s112222)])

        // When

        extended.reset()
        sut.s1.s11.s112.s1122.s11222.transition(
            to: sut.s1.s11.s112.s1122.s11222.s112221,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       #-v--#                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       #----#--------------------------------------------------------------------------------#  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   #-v----------------------------------------------------------------#  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               #-v-----#                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   #-------#--------#-----------+------------------#  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H  v       *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   #---------#   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   #---------#   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   #----------------#------------------------------#  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   #------------------------------------------------------------------#  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive) // initial
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertTrue(sut.s1.s11.s112.s1122.s11222.s112221.isActive) // target
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1122.s11221,
                         sut.s1.s11.s112.s1122.s11222.s112221,
                         sut.s1.s12.s121,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112.s1122.s11222.s112222),
                        .transitionAction,
                        .entry(sut.s1.s11.s112.s1122.s11222.s112221)])

        // When

        extended.reset()
        sut.s1.s11.s112.s1122.s11221.transition(
            to: sut.s1.s11.s112.s1121,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       +-v--+                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       +----+--------------------------------------------------------------------------------+  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   +-v----------------------------------------------------------------+  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               +-v-----+                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +----+----+   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |        |                     |  |  |  |
        //    |    |  |   |       |   |   +-------+   +----------------+--------|---------------------+  |  |  |
        //    |    |  |   |       |   |        ^--------------------------------+                        |  |  |
        //    |    |  |   +-------+   +------------------------------------------------------------------+  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 +-------------------------------------------------------------------------------------+  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive) // initial
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive) // target
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s11.s112.s1122.s11221),
                        .exit(sut.s1.s11.s112.s1122.s11222.s112221),
                        .exit(sut.s1.s11.s112.s1122.s11222),
                        .transitionAction,
                        .entry(sut.s1.s11.s112.s1121), // join triggered
                        .exit(sut.s1.s11.s112.s1121),
                        .exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s121),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s122,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |  +-J1 #-------------------------------------------------------------------------------------#  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   #--------#                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    |  |    |   |        |   |        |                                                           |  |
        //    |  |    |   +--------+   #--------#                                                           |  |
        //    +----------------------------^                                                                |  |
        //    |  |    #-------------------------------------------------------------------------------------#  |
        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive) // initial
        XCTAssertTrue(sut.s1.s11.s112.s1121.isActive) // in history
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive) // initial
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive) // target
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive) // initial
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s122.isActive)
        XCTAssertTrue(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112.s1121,
                         sut.s1.s12.s122,
                         sut.s1.s13))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s2),
                        .transitionAction,
                        .entry(sut.s1.s11),
                        .entry(sut.s1.s11.s112),
                        .entry(sut.s1.s11.s112.s1121),
                        .entry(sut.s1.s13),
                        .entry(sut.s1.s12),
                        .entry(sut.s1.s12.s122)])

        // When

        extended.reset()
        sut.transition(
            to: sut.s1.s12.s121,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        //    #------------------------------------------------------------------------------------------------#
        //    |   H     *                                                                                      |
        //    |       +-v--+                                                                                   |
        //    |       | S1 |                                                                                   |
        //    |       +----+--------------------------------------------------------------------------------+  |
        //    |       | S11             *                                                                   |  |
        //    |       |   +-------+   +-v----------------------------------------------------------------+  |  |
        //    |       |   | S111  |   | S112 H*         *                                                |  |  |
        //    |       |   |       |   |               +-v-----+                                          |  |  |
        //    |       |   |       |   |               | S1122 |                                          |  |  |
        //    |       |   |       |   |   +-------+   +-------+--------+------------------------------+  |  |  |
        //    |       |   |       |   |   | S1121 |   | S11221         | S11222 H          *          |  |  |  |
        //    |       |   |       |   |   |       |   |   +---------+  |   +---------+   +-v-------+  |  |  |  |
        //    |       |   |       |   |   |       |   |   | S112211 |  |   | S112221 |   | S112222 |  |  |  |  |
        //    |       |   |       |   |   |       |   |   |         |  |   |         |   |         |  |  |  |  |
        //    |    +----------------------O       |   |   +---------+  |   +---------+   +---------+  |  |  |  |
        //    |    |  |   |       |   |   |       |   |                |                              |  |  |  |
        //    |    |  |   |       |   |   +-------+   +----------------+------------------------------+  |  |  |
        //    |    |  |   |       |   |                                                                  |  |  |
        //    |    |  |   +-------+   +------------------------------------------------------------------+  |  |
        //    |    |  |                                                                                     |  |
        //    |  +-J1 +-------------------------------------------------------------------------------------+  |
        //    |  | |  | S12 H                                                                               |  |
        //    |  | |  |   +--------+   +--------+                                                           |  |
        //    |  | +------O S121   |   | S122   |                                                           |  |
        //    +---------->|        |   |        |                                                           |  |
        //    |  |    |   +--------+   +--------+                                                           |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    | S13                                                                                 |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |   | S131   |                                                                        |  |
        //    |  |    |   |        |                                                                        |  |
        //    |  |    |   +--------+                                                                        |  |
        //    |  |    |                                                                                     |  |
        //    |  |    +-------------------------------------------------------------------------------------+  |
        //    |  |    #----------------------------#                                                           |
        //    |  +----> S2                         |                                                           |
        //    |       |                            |                                                           |
        //    |       #----------------------------#                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.exit(sut.s1.s12.s122),
                        .transitionAction,
                        .entry(sut.s1.s12.s121), // join triggered
                        .exit(sut.s1.s11.s112.s1121),
                        .exit(sut.s1.s11.s112),
                        .exit(sut.s1.s11),
                        .exit(sut.s1.s12.s121),
                        .exit(sut.s1.s12),
                        .exit(sut.s1.s13),
                        .entry(sut.s2)])

        // When

        extended.reset()
        sut.transition(
            to: sut,
            action: { extended.transitionSequence.append(.transitionAction) }
        )

        // history brings it back to s2

        //    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
        //    |  |    #----------------------------#                                                           |
        //    |  +----> S2                         |                                                           |
        //    |       |                            |                                                           |
        //    |       #----------------------------#                                                           |
        //    #------------------------------------------------------------------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1121.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11221.s112211.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112221.isActive)
        XCTAssertFalse(sut.s1.s11.s112.s1122.s11222.s112222.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s1.s13.isActive)
        XCTAssertFalse(sut.s1.s13.s131.isActive)
        XCTAssertTrue(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.transitionAction])
    }
}
