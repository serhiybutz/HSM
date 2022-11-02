//
//  Queue.swift
//  HSM
//
//  Created by Serhiy Butz on 04/19/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

///
/// A standard queue (FIFO - First In First Out).
///

class Queue<E> {
    class DummyItem {
        var next: DummyItem?
    }

    final class Item<E>: DummyItem {
        let value: E
        init(_ newValue: E) {
            self.value = newValue
        }
    }

    var head: DummyItem
    var tail: DummyItem

    private(set) var count: Int = 0

    init() {
        tail = DummyItem()
        head = tail
    }

    func enqueue(_ value: E) {
        tail.next = Item(value)
        tail = tail.next!
        count += 1
    }

    func dequeue() -> E? {
        if let head = head.next {
            self.head = head
            count -= 1
            return (head as! Item<E>).value
        } else {
            return nil
        }
    }

    func peek() -> E? {
        if let head = head.next {
            return (head as! Item<E>).value
        } else {
            return nil
        }
    }

    var isEmpty: Bool {
        let isEmpty = count == 0
        if isEmpty {
            precondition(head === tail)
        }
        return isEmpty
    }
}
