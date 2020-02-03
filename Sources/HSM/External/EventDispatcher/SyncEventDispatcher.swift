//
//  SyncEventDispatcher.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

public final class SyncEventDispatcher<E: EventProtocol>: EventDispatching, DispatchingDelegateInjected, SimplyInitializable {
    static var name: String { "\(Self.self)" }
    private var queue = DispatchQueue(label: "com.irizen.HSM.\(SyncEventDispatcher.name).SerialQueue", qos: .userInteractive)
    unowned var delegate: Dispatching!
    public init() {}
    public func dispatch(_ event: E) {
        queue.sync {
            self.delegate.dispatch(event)
        }
    }
}
