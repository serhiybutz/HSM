//
//  DispatchTests.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import XCTest
@testable
import HSM

final class DispatchTests: XCTestCase {
    func test_01() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM01(extended)

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

        // When

        extended.reset()
        sut.dispatch(.init(), completion: { XCTAssert($0) })

        //    #-----------#
        //    |           |
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
                       [.handle(sut)])
    }

    func test_02() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM02(extended)

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
                       [])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1), completion: { XCTAssert($0) })

        //    #--------------------#
        //    |                    |
        //    |  #-----#  +-----+  |
        //    |  | S1  |  | S2  |  |
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
                       [.handle(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2))

        //    #--------------------#
        //    |                    |
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
                       [.handle(sut.s1)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut), completion: { XCTAssert($0) })

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
                       [.handle(sut.s2)])
    }

    func test_03() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM03(extended)

        // When

        sut.start()

        //    #--------------------------#
        //    |                          |
        //    |  +--------------------+  |
        //    |  | S1         *       |  |
        //    |  |  +-----+  +v----+  |  |
        //    |  |  | S11 |  | S12 |  |  |
        //    |  |  |     |  |     |  |  |
        //    |  |  +-----+  +-----+  |  |
        //    |  |                    |  |
        //    |  +--------------------+  |
        //    |                          |
        //    #--------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertFalse(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1), completion: { XCTAssert($0) })

        //    #--------------------------#
        //    |                          |
        //    |  #--------------------#  |
        //    |  | S1         *       |  |
        //    |  |  +-----+  #v----#  |  |
        //    |  |  | S11 |  | S12 |  |  |
        //    |  |  |     |  |     |  |  |
        //    |  |  +-----+  #-----#  |  |
        //    |  |                    |  |
        //    |  #--------------------#  |
        //    |                          |
        //    #--------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertFalse(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1.s11), completion: { XCTAssert($0) })

        //    #--------------------------#
        //    |                          |
        //    |  =--------------------=  |
        //    |  | S1         *       |  |
        //    |  |  #-----#  +v----+  |  |
        //    |  |  | S11 |  | S12 |  |  |
        //    |  |  |     |  |     |  |  |
        //    |  |  #-----#  +-----+  |  |
        //    |  |                    |  |
        //    |  =--------------------=  |
        //    |                          |
        //    #--------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s12.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s1.s12),
                        .handle(sut.s1)]) // hierarchical handling by s1

    }

    func test_04() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM04(extended)

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

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut))

        XCTAssertEqual(extended.transitionSequence,
                       [])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s0.s1.s11.s112.s1122), completion: { XCTAssert($0) })

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

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11.s111,
                         sut.s0.s1.s11.s112.s1122,
                         sut.s0.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s0.s2.s21), completion: { XCTAssert($0) })

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
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   #--------#   +--------+                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   #--------#   +--------+                               |   |
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
        XCTAssertTrue(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11.s111,
                         sut.s0.s1.s11.s112.s1122,
                         sut.s0.s2.s21))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s0.s1.s11.s111),
                        .handle(sut.s0.s1.s11.s112.s1122),
                        .handle(sut.s0.s2)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s0.s2.s22), completion: { XCTAssert($0) })

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
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   +---------+   |   +---------+   #---------#   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   =--------=   #--------#                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   =--------=   #--------#                               |   |
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
        XCTAssertTrue(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11.s111,
                         sut.s0.s1.s11.s112.s1122,
                         sut.s0.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s0.s1.s11.s111),
                        .handle(sut.s0.s1.s11.s112.s1122),
                        .handle(sut.s0.s2.s21)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s0.s1.s11.s111.s1111), completion: { XCTAssert($0) })

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
        //    |   |   |   #---------#   |   +---------+   #---------#   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   #---------#   |   +---------+   #---------#   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   #-----------------#-------------------------------#   |   |
        //    |   |                                                         |   |
        //    |   #---------------------------------------------------------#   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   #--------#                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   #--------#                               |   |
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
        XCTAssertTrue(sut.s0.s1.s11.s111.s1111.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.isActive)
        XCTAssertFalse(sut.s0.s1.s11.s112.s1121.isActive)
        XCTAssertTrue(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertTrue(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)
        
        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11.s111.s1111,
                         sut.s0.s1.s11.s112.s1122,
                         sut.s0.s2.s22))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s0.s1.s11.s111),
                        .handle(sut.s0.s1.s11.s112.s1122),
                        .handle(sut.s0.s2.s22)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s3), completion: { XCTAssert($0) })

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
        //    |   |   |   =---------=   |   +---------+   =---------=   |   |   |
        //    |   |   |   | S1111   |   |   | S1121   |   | S1122   |   |   |   |
        //    |   |   |   |         |   |   |         |   |         |   |   |   |
        //    |   |   |   =---------=   |   +---------+   =---------=   |   |   |
        //    |   |   |                 |                               |   |   |
        //    |   |   +-----------------+-------------------------------+   |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |   | S2                                                      |   |
        //    |   |   +--------+   =--------=                               |   |
        //    |   |   | S21    |   | S22    |                               |   |
        //    |   |   |        |   |        |                               |   |
        //    |   |   +--------+   =--------=                               |   |
        //    |   |                                                         |   |
        //    |   +---------------------------------------------------------+   |
        //    |                                                                 |
        //    |   #---------#                                                   |
        //    |   | S3      |                                                   |
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
        XCTAssertTrue(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s3))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s0.s1.s11.s111.s1111),
                        .handle(sut.s0.s1.s11.s112.s1122),
                        .handle(sut.s0.s2.s22)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s0.s1), completion: { XCTAssert($0) })

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
        //    |   =---------=                                                   |
        //    |   | S3      |                                                   |
        //    |   |         |                                                   |
        //    |   =---------=                                                   |
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
        XCTAssertFalse(sut.s0.s1.s11.s112.s1122.isActive)
        XCTAssertTrue(sut.s0.s2.isActive)
        XCTAssertFalse(sut.s0.s2.s21.isActive)
        XCTAssertFalse(sut.s0.s2.s22.isActive)
        XCTAssertFalse(sut.s3.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s0.s1.s11.s111,
                         sut.s0.s1.s11.s112,
                         sut.s0.s2))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s3)])
    }

    func test_05() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM05(extended)

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
                       [])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2), completion: { XCTAssert($0) })

        //    #------------------------------------#
        //    |                                    |
        //    |       #----#                       |
        //    |       | S1 |                       |
        //    |       #----#--------------------#  |
        //    |       | S11                     |  |
        //    |       | #------#   +------+     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | #------#   +------+     |  |
        //    |    |  |                         |  |
        //    |    |  #-------------------------#  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | #-----------#  +------+ |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | #-------# |  |      | |  |
        //    |  | +------> S1211 | |  +------+ |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | #-------# |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | #-----------#           |  |
        //    |  |    |                         |  |
        //    |  |    #-------------------------#  |
        //    |  |                                 |
        //    |  |    +------+                     |
        //    |  +----O S2   |                     |
        //    |       |      |                     |
        //    |       +------+                     |
        //    |                                    |
        //    #------------------------------------#

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
                       [.handle(sut)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s2), completion: { XCTAssert($0) })

        //    #------------------------------------#
        //    |                                    |
        //    |       #----#                       |
        //    |       | S1 |                       |
        //    |       #----#--------------------#  |
        //    |       | S11                     |  |
        //    |       | #------#   +------+     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | #------#   +------+     |  |
        //    |    |  |                         |  |
        //    |    |  #-------------------------#  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | #-----------#  +------+ |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | #-------# |  |      | |  |
        //    |  | +------> S1211 | |  +------+ |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | #-------# |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | #-----------#           |  |
        //    |  |    |                         |  |
        //    |  |    #-------------------------#  |
        //    |  |                                 |
        //    |  |    +------+                     |
        //    |  +----O S2   |                     |
        //    |       |      |                     |
        //    |       +------+                     |
        //    |                                    |
        //    #------------------------------------#

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
                       [.handle(sut.s1.s11.s111),
                        .handle(sut.s1.s12.s121.s1211)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1.s11.s112), completion: { XCTAssert($0) })

        //    #------------------------------------#
        //    |                                    |
        //    |       #----#                       |
        //    |       | S1 |                       |
        //    |       #----#--------------------#  |
        //    |       | S11                     |  |
        //    |       | =------=   #------#     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | =------=   #------#     |  |
        //    |    |  |                         |  |
        //    |    |  #-------------------------#  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | #-----------#  +------+ |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | #-------# |  |      | |  |
        //    |  | +------> S1211 | |  +------+ |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | #-------# |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | #-----------#           |  |
        //    |  |    |                         |  |
        //    |  |    #-------------------------#  |
        //    |  |                                 |
        //    |  |    +------+                     |
        //    |  +----O S2   |                     |
        //    |       |      |                     |
        //    |       +------+                     |
        //    |                                    |
        //    #------------------------------------#

        // Then

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertFalse(sut.s1.s11.s111.isActive)
        XCTAssertTrue(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertTrue(sut.s1.s12.s121.isActive)
        XCTAssertTrue(sut.s1.s12.s121.s1211.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s121.s1211))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut.s1.s11.s111),
                        .handle(sut.s1.s12.s121.s1211)])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1.s12.s122), completion: { XCTAssert($0) })

        //    #------------------------------------#
        //    |                                    |
        //    |       #----#                       |
        //    |       | S1 |                       |
        //    |       #----#--------------------#  |
        //    |       | S11                     |  |
        //    |       | +------+   #------#     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | +------+   #------#     |  |
        //    |    |  |                         |  |
        //    |    |  #-------------------------#  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | =-----------=  #------# |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | =-------= |  |      | |  |
        //    |  | +------> S1211 | |  #------# |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | =-------= |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | #-----------#           |  |
        //    |  |    |                         |  |
        //    |  |    #-------------------------#  |
        //    |  |                                 |
        //    |  |    +------+                     |
        //    |  +----O S2   |                     |
        //    |       |      |                     |
        //    |       +------+                     |
        //    |                                    |
        //    #------------------------------------#

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
                       [.handle(sut.s1.s11.s112),
                        .handle(sut.s1.s12.s121.s1211)])

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s112,
                         sut.s1.s12.s122))

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut), completion: { XCTAssert($0) })

        //    #------------------------------------#
        //    |                                    |
        //    |       =----=                       |
        //    |       | S1 |                       |
        //    |       =----=--------------------=  |
        //    |       | S11                     |  |
        //    |       | +------+   =------=     |  |
        //    |       | | S111 |   | S112 |     |  |
        //    |    +---->      |   |      |     |  |
        //    |    |  | +------+   =------=     |  |
        //    |    |  |                         |  |
        //    |    |  =-------------------------=  |
        //    |  +-F1 | S12                     |  |
        //    |  | |  | +-----------+  =------= |  |
        //    |  | |  | | S121      |  | S122 | |  |
        //    |  | |  | | +-------+ |  |      | |  |
        //    |  | +------> S1211 | |  =------= |  |
        //    |  |    | | |       | |           |  |
        //    |  |    | | +-------+ |           |  |
        //    |  |    | |           |           |  |
        //    |  |    | +-----------+           |  |
        //    |  |    |                         |  |
        //    |  |    =-------------------------=  |
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
                       [.handle(sut.s1.s11.s112),
                        .handle(sut.s1.s12.s122)])
    }

    func test_06() {
        // Given

        let extended = Extended()
        let sut = DispatchHSM06(extended)

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
                       [])

        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1.s11.s111), completion: { XCTAssert($0) })

        //    #--------------------------------------#
        //    |       #----#                         |
        //    |       | S1 |                         |
        //    |       #----#---------------------#   |
        //    |       | S11             *        |   |
        //    |       |   #-------#   +-v-----+  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   #-------#   +-------+  |   |
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

        XCTAssertTrue(sut.isActive)
        XCTAssertTrue(sut.s1.isActive)
        XCTAssertTrue(sut.s1.s11.isActive)
        XCTAssertTrue(sut.s1.s11.s111.isActive)
        XCTAssertFalse(sut.s1.s11.s112.isActive)
        XCTAssertTrue(sut.s1.s12.isActive)
        XCTAssertFalse(sut.s1.s12.s121.isActive)
        XCTAssertFalse(sut.s1.s12.s122.isActive)
        XCTAssertFalse(sut.s2.isActive)

        XCTAssertEqual(E(sut.activeStateConfiguration()),
                       E(sut.s1.s11.s111,
                         sut.s1.s12))

        XCTAssertEqual(extended.transitionSequence,
                       [.handle(sut)])


        // When

        extended.reset()
        sut.dispatch(.init(nextState: sut.s1.s12.s121), completion: { XCTAssert($0) })

        //    #--------------------------------------#
        //    |       =----=                         |
        //    |       | S1 |                         |
        //    |       =----=---------------------=   |
        //    |       | S11             *        |   |
        //    |       |   =-------=   +-v-----+  |   |
        //    |       |   | S111  |   | S112  |  |   |
        //    |    +------O       |   |       |  |   |
        //    |    |  |   =-------=   +-------+  |   |
        //    |    |  |                          |   |
        //    |  +-J1 =--------------------------=   |
        //    |  | |  | S12 H                    |   |
        //    |  | |  |   =-------=   +-------+  |   |
        //    |  | +------O S121  |   | S122  |  |   |
        //    |  |    |   |       |   |       |  |   |
        //    |  |    |   =-------=   +-------+  |   |
        //    |  |    |                          |   |
        //    |  |    =--------------------------=   |
        //    |  |                                   |
        //    |  |    #--------------------------#   |
        //    |  +----> S2                       |   |
        //    |       |                          |   |
        //    |       #--------------------------#   |
        //    #--------------------------------------#

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
                       [.handle(sut.s1.s11.s111),
                        .handle(sut.s1.s12)])
    }
}
