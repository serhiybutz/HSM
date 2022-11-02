//
//  Vertex.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

/// `Vertex` differs from `BaseState` in that it has a reference to a superior state.
open class Vertex<P: StateBasic, U: TopStateEventTypeProtocol>: BaseState<U> {
    // MARK: - BindingState

    public var superior: P {
        let superior = `internal`.location.superior
            ?? `internal`!
        return superior.external as! P
    }
}
