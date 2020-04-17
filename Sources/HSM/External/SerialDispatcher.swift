//
//  SerialDispatcher.swift
//  HSM
//
//  Created by Serge Bouts on 4/17/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

// Allows arbitrary use of nested sync/async calls
final class SerialDispatcher {
    // MARK: - State

    static var name: String { "\(Self.self)" }

    // Note: SerialDispatcher works with serial queues only!
    let queue = DispatchQueue(label: "com.irizen.HSM.\(SerialDispatcher.name).SerialQueue", qos: .userInteractive)

    var isUnderQueue = false

    // MARK: - UI

    @discardableResult
    public func sync<T>(execute work: () throws -> T) rethrows -> T {
        if isUnderQueue {
            return try work()
        } else {
            return try queue.sync {
                isUnderQueue = true
                defer { isUnderQueue = false }
                return try work()
            }
        }
    }

    public func async(execute work: @escaping () -> Void) -> Void {
        queue.async {
            precondition(!self.isUnderQueue)
            self.isUnderQueue = true
            defer { self.isUnderQueue = false }
            work()
        }
    }
}
