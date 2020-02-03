//
//  BindingState.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public protocol BindingState: StateBasic {
    associatedtype TopStateType: TopStateEventTypeProtocol
    associatedtype SuperiorType: StateBasic
    var top: TopStateType { get }
    var superior: SuperiorType { get }
}

extension BindingState {
    public func bind(_ states: Vertex<Self, TopStateType>...) {
        let `internal` = (self as! InternalReferencing).internal!
        for s in states {
            switch s {
            case is StateProtocol:
                let iVertex = IVertex(
                    location: .init(superior: `internal`),
                    region: `internal`.region,
                    external: s)
                s.internal = iVertex
            case is ClusterProtocol:
                let iCluster = IRegionCluster(
                    location: .init(superior: `internal`),
                    region: `internal`.region,
                    external: s,
                    subregions: [])
                s.internal = iCluster
            case is ForkProtocol:
                let iFork = IFork(
                    location: .init(superior: `internal`),
                    region: `internal`.region,
                    external: s,
                    outgoings: []
                )
                s.internal = iFork
            case is JoinProtocol:
                let iJoin = IJoin(
                    location: .init(superior: `internal`),
                    region: `internal`.region,
                    external: s,
                    incomings: []
                )
                s.internal = iJoin
            default: break
            }
            s._top = top
            s.initialize()
        }
    }
}
