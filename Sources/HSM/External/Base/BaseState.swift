//
//  BaseState.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

open class BaseState<U: TopStateEventTypeProtocol>: InternalReferencing, StateBasic {
    // MARK: - InternalReferencing

    var `internal`: IStateBase!

    // MARK: -

    unowned var _top: U!
    public var top: U { _top! }

    // MARK: - Initialization

    public init() {}

    // MARK: - StateBasic

    open func initialize() {}
    public var isActive: Bool { `internal`.isActive }
}

extension BaseState: StateQueries {
    // MARK: - Queries

    public var superiorState: StateBasic? {
        `internal`.location.superior?.external as! StateBasic?
    }

    public var representsRegion: Bool {
        let superior = `internal`.location.superior
        return superior is IRegionCluster || superior == nil
    }

    public var activeStateInRegion: StateBasic? {
        `internal`.region.activeState?.external as! StateBasic?
    }
}
