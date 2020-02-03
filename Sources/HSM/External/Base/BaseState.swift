//
//  BaseState.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
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
