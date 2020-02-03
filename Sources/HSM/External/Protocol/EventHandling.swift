//
//  EventHandling.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

protocol EventHandling: StateProtocol {
    associatedtype EventType: EventProtocol
    func handle(_ event: EventType) -> Transition?
}

protocol DowncastingEventHandling: StateProtocol {
    func _handle(_ event: EventProtocol) -> Transition?
}
