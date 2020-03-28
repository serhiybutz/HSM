//
//  AnyEventDispatcher.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public struct AnyEventDispatcher<E: EventProtocol>: EventDispatching {
    let _dispatch: (E, DispatchCompletion?) -> Void
    public init<ED: EventDispatching>(_ eventDispatcher: ED) where ED.EventType == E {
        self._dispatch = eventDispatcher.dispatch
    }
    public func dispatch(_ event: E, completion: DispatchCompletion?) {
        _dispatch(event, completion)
    }
}
