//
//  EventDispatching.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public protocol EventDispatching {
    associatedtype EventType: EventProtocol
    func start()
    func dispatch(_ event: EventType, completion: ((Bool) -> Void)?)
}
