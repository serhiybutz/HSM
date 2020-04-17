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

    // MARK: - Properties

    let rootRegion = IRegion()

    let dispatcher = SerialDispatcher()

    // MARK: - Initialization

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

    public func dispatch(_ event: E, async: Bool = false, completion: DispatchCompletion? = nil) {
#if DebugVerbosityLevel2
        os_log("### [%s:%s] Dispatching event {%s}", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)")
#endif
        if async {
            dispatcher.async {
                self.rootRegion.dispatch(event, completion: completion)
            }
        } else {
            dispatcher.sync {
                self.rootRegion.dispatch(event, completion: completion)
            }
        }
    }

    @discardableResult
    public func access<T>(_ block: () -> T) -> T {
        dispatcher.sync(execute: block)
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
