//
//  TopState.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

/// The top state, the purpose of which is to provide the ultimate root of the state hierarchy so that the state handlers can use `top` to refer to the whole state hierarchy.
open class TopState<E: EventProtocol>: InternalReferencing, StateAttributes, EventHandling, TopStateEventTypeProtocol, TopStateProtocol {
    public typealias EventType = E

    final class InternalTopState: IVertex {}

    // MARK: - InternalReferencing

    var `internal`: IStateBase!

    // MARK: -

    let rootRegion = IRegion()

    let eventDispatcher: AnyEventDispatcher<E>

    public let actionDispatcher: ActionDispatching

    // MARK: - Initilization

    public init<ED: EventDispatching & SimplyInitializable>(eventDispatcherType: ED.Type, shouldRunActionsInMainThread: Bool = true) where ED.EventType == E {
        let eventDispatcher = eventDispatcherType.init()
        self.eventDispatcher = AnyEventDispatcher<E>(eventDispatcher)
        self.actionDispatcher = TopState.makeActionDispatcher(shouldRunActionsInMainThread)
        commonSetup(eventDispatcher: eventDispatcher)
    }

    public init(shouldRunActionsInMainThread: Bool = true) {
        let eventDispatcher = AsyncEventDispatcher<E>()
        self.eventDispatcher = AnyEventDispatcher<E>(eventDispatcher)
        self.actionDispatcher = TopState.makeActionDispatcher(shouldRunActionsInMainThread)
        commonSetup(eventDispatcher: eventDispatcher)
    }

    static func makeActionDispatcher(_ shouldRunActionsInMainThread: Bool) -> ActionDispatching {
        shouldRunActionsInMainThread
            ? MainThreadSyncActionDispatcher()
            : FormalActionDispatcher()
    }

    func commonSetup<ED: EventDispatching & SimplyInitializable>(eventDispatcher: ED) {
        let topState = InternalTopState(
            location: .init(),
            region: rootRegion,
            external: self)
        `internal` = topState
        // Injections:
        rootRegion.rootState = topState
        rootRegion.actionDispatcher = actionDispatcher
        (eventDispatcher as? DispatchingDelegateInjected)?.delegate = rootRegion
    }

    // MARK: - Properties

    public var initial: StateBasic? {
        get { ((rootRegion.rootState as! IStateAttributes).initial as! IVertex?)?.external as! StateBasic? }
        set { (rootRegion.rootState as! IStateAttributes).initial = (newValue as! InternalReferencing?)?.internal }
    }

    public var historyMode: HistoryMode {
        get { (rootRegion.rootState as! IVertex).historyMode }
        set { (rootRegion.rootState as! IVertex).historyMode = newValue }
    }

    // MARK: - Lifecycle

    open func initialize() {}
    open func entry() {}
    open func exit() {}
    open func handle(_ event: E) -> Transition? { nil }

    // MARK: - UI

    public func start() {
        initialize()
        rootRegion.transition(to: rootRegion.rootState!)
    }

    public func dump() -> String {
        var result = ""
        let mirror = Mirror(reflecting: self)
        Swift.dump(
            self,
            to: &result,
            name: "\(mirror.subjectType)"
        )
        return result
    }

    public var isActive: Bool { `internal`.isActive }

    public func dispatch(_ event: E) {
#if DebugVerbosityLevel2
        os_log("### [%s:%s] Dispatching event {%s}", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)")
#endif
        eventDispatcher.dispatch(event)
    }
}

// MARK: - Traits

extension TopState: BindingTopState, Transitioning {}
extension TopState: DowncastingEventHandling {
    func _handle(_ event: EventProtocol) -> Transition? {
        handle(event as! E)
    }
}
