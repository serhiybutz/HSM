//
//  QueueTests.swift
//  HSM
//
//  Created by Serhiy Butz on 04/19/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//


import XCTest
@testable import HSM

final class QueueTests: XCTestCase {
    func testAdd1ToQueue() {
        let sut = Queue<String>()
        sut.enqueue("1")
    }

    func testAddSeveralToQueue() {
        let sut = Queue<String>()
        XCTAssert(sut.isEmpty)
        sut.enqueue("1")
        sut.enqueue("1")
        XCTAssertFalse(sut.isEmpty)
        sut.enqueue("1")
        sut.enqueue("1")
        sut.enqueue("1")
    }

    func testRemoveOne() {
        let sut = Queue<String>()
        sut.enqueue("1")
        sut.enqueue("")
        sut.enqueue("")
        sut.enqueue("")
        let thefirstone = sut.dequeue()

        XCTAssertNotNil(thefirstone)
        XCTAssertEqual(thefirstone!, "1")
    }

    func testRemoveAll() {
        let sut = Queue<String>()
        sut.enqueue("1")
        sut.enqueue("2")
        sut.enqueue("3")
        sut.enqueue("4")

        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssertEqual(sut.dequeue()!, "3")
        XCTAssertEqual(sut.dequeue()!, "4")
        XCTAssert(sut.isEmpty)
        XCTAssertNil(sut.dequeue())
        XCTAssertNil(sut.dequeue())
        XCTAssert(sut.isEmpty)
    }

    func testGenerics() {
        let sut = Queue<Int>()
        sut.enqueue(1)
        sut.enqueue(2)
        sut.enqueue(3)
        sut.enqueue(4)

        XCTAssertEqual(sut.dequeue()!, 1)
        XCTAssertEqual(sut.dequeue()!, 2)
        XCTAssertEqual(sut.dequeue()!, 3)
        XCTAssertEqual(sut.dequeue()!, 4)
    }

    func testAddNil() {
        let sut = Queue<Int?>()
        sut.enqueue(nil)
        XCTAssertNil(sut.dequeue()!)

        sut.enqueue(2)
        sut.enqueue(nil)
        sut.enqueue(4)

        XCTAssertEqual(sut.dequeue()!!, 2)
        XCTAssertNil(sut.dequeue()!)
        XCTAssertEqual(sut.dequeue()!!, 4)
    }

    func testAddAfterEmpty() {
        let sut = Queue<String>()

        sut.enqueue("1")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertNil(sut.dequeue())

        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssert(sut.isEmpty)
        XCTAssertNil(sut.dequeue())
    }

    func testAddAndRemoveChaotically() {
        let sut = Queue<String>()

        sut.enqueue("1")
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssert(sut.isEmpty)
        XCTAssertNil(sut.dequeue())

        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssert(sut.isEmpty)
        XCTAssertNil(sut.dequeue())

        sut.enqueue("1")
        sut.enqueue("2")
        XCTAssertEqual(sut.dequeue()!, "1")
        sut.enqueue("3")
        sut.enqueue("4")
        XCTAssertEqual(sut.dequeue()!, "2")
        XCTAssertEqual(sut.dequeue()!, "3")
        XCTAssertFalse(sut.isEmpty)
        XCTAssertEqual(sut.dequeue()!, "4")
        XCTAssertNil(sut.dequeue())
        XCTAssertNil(sut.dequeue())
    }
}
