//
//  TopState.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation
import os.log

/// The top state, the purpose of which is to provide the ultimate root of the state hierarchy so that the state handlers can use `top` to refer to the whole state hierarchy.
open class TopState<E: EventProtocol>: InternalReferencing, StateAttributes, EventHandling, TopStateEventTypeProtocol, TopStateProtocol {
    // MARK: - Types

    public typealias EventType = E

    final class InternalTopState: IVertex {}

    // MARK: - InternalReferencing

    var `internal`: IStateBase!

    // MARK: - Properties

    let rootRegion = IRegion()

    let dispatcher = SerialDispatcher()

    var localEventsQueue = Queue<E>()

    private(set) var isDispatching: Bool = false

    public init(shouldRunActionsInMainThread: Bool = true) {
        let topState = InternalTopState(
            location: .init(),
            region: rootRegion,
            external: self)
        `internal` = topState
        // Injections:
        rootRegion.rootState = topState
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
    open func always() -> Transition? { nil }
    open func handle(_ event: E) -> Transition? { nil }

    // MARK: - UI

    public var isActive: Bool { `internal`.isActive }

    public func start() {
        dispatcher.sync {
            rootRegion.start()
        }
    }

    public func dispatch(_ event: E, isAsync: Bool = false, completion: DispatchCompletion? = nil) {
#if DebugVerbosityLevel2
        os_log("### [%s:%s] Dispatching event {%s}", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)")
#endif

        // When called from within dispatching, we force async mode for RTC
        var isAsync = isAsync
        if isDispatching {
            isAsync = true
        }

        if isAsync {
            dispatcher.async {
                self.internalDispatch(event, completion: completion)
            }
        } else {
            dispatcher.sync {
                self.internalDispatch(event, completion: completion)
            }
        }
    }

    /// Schedule local dispatching
    public func dispatchLocal(_ event: E) {
#if DebugVerbosityLevel2
        os_log("### [%s:%s] Dispatching local event {%s}", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)")
#endif
        precondition(isDispatching, "Local dispatching is only allowed inside the normal dispatching!")
        dispatchPrecondition(condition: .onQueue(dispatcher.queue))
        localEventsQueue.enqueue(event)
    }

    @discardableResult
    public func access<T>(_ block: () -> T) -> T {
        dispatcher.sync(execute: block)
    }

    // MARK: - Helpers

    func internalDispatch(_ event: E, completion: DispatchCompletion? = nil) {
        isDispatching = true
        defer { isDispatching = false }

        // Perform actual dispatching
        let isConsumed = self.rootRegion.dispatch(event)

        dispatchLocalEventsIfAny()

        completion?(isConsumed)
    }

    func dispatchLocalEventsIfAny() {
        while !localEventsQueue.isEmpty {
            let event = localEventsQueue.dequeue()!
            // just ignore `isConsumed` reporting for local dispatches
            _ = self.rootRegion.dispatch(event)
        }
    }

    // MARK: - Debugging

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

    public func activeStateConfiguration() -> [StateBasic] {
        rootRegion.activeStateConfiguration().map { $0.external as! StateBasic }
    }
}

// MARK: - Queries

extension TopState: StateQueries {
    public var superiorState: StateBasic? {
        precondition(`internal`.location.superior == nil)
        return nil
    }

    public var representsRegion: Bool {
        return true
    }

    public var activeStateInRegion: StateBasic? {
        precondition(`internal`.region === rootRegion)
        return rootRegion.activeState?.external as! StateBasic?
    }
}

// MARK: - Traits

extension TopState: BindingTopState, Transitioning {}
extension TopState: DowncastingEventHandling {
    func _handle(_ event: EventProtocol) -> Transition? {
        handle(event as! E)
    }
}
