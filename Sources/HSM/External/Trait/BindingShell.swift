//
//  BindingTopState.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public protocol BindingTopState: StateBasic {}

extension BindingTopState where Self: TopStateEventTypeProtocol {
    public func bind(_ states: Vertex<Self, Self>...) {
        let `internal` = (self as! TopStateProtocol).internal!
        let rootRegion = (self as! TopStateProtocol).rootRegion
        for s in states {
            switch s {
            case is StateProtocol:
                let iVertex = IVertex(
                    location: .init(superior: `internal`),
                    region: rootRegion,
                    external: s)
                s.internal = iVertex
            case is ClusterProtocol:
                let iCluster = IRegionCluster(
                    location: .init(superior: `internal`),
                    region: rootRegion,
                    external: s,
                    subregions: [])
                s.internal = iCluster
            case is ForkProtocol:
                let iFork = IFork(
                    location: .init(superior: `internal`),
                    region: rootRegion,
                    external: s,
                    outgoings: []
                )
                s.internal = iFork
            case is JoinProtocol:
                let iJoin = IJoin(
                    location: .init(superior: `internal`),
                    region: rootRegion,
                    external: s,
                    incomings: []
                )
                s.internal = iJoin
            default: break
            }
            s._top = self
            s.initialize()
        }
    }
}
