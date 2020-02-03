//
//  State.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

open class State<P: StateBasic, U: TopStateEventTypeProtocol>: Vertex<P, U>, EventHandling, StateAttributes {
    typealias EventType = U.EventType

    // MARK: - Properties

    public var initial: StateBasic? {
        get { ((`internal`! as! IVertex).initial as! IVertex?)?.external as! StateBasic? }
        set { (`internal`! as! IVertex).initial = (newValue as! InternalReferencing?)?.internal }
    }

    public var historyMode: HistoryMode {
        get { (`internal`! as! IVertex).historyMode }
        set { (`internal`! as! IVertex).historyMode = newValue }
    }

    // MARK: - Lifecycle

    open func entry() {}
    open func exit() {}
    open func handle(_ event: U.EventType) -> Transition? { nil }
}

// MARK: - Traits

extension State: BindingState, Transitioning {}

extension State: DowncastingEventHandling {
    func _handle(_ event: EventProtocol) -> Transition? {
        handle(event as! EventType)
    }
}
