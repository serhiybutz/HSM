//
//  BindingCluster.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public protocol BindingCluster: StateBasic {
    associatedtype TopStateType: TopStateEventTypeProtocol
    associatedtype SuperiorType: StateBasic
    var top: TopStateType { get }
    var superior: SuperiorType { get }
}

extension BindingCluster {
    public func bind(_ states: Vertex<Self, TopStateType>...) {
        let `internal` = (self as! InternalReferencing).internal!
        var regions: [IRegion] = []
        for s in states {
            s._top = top
            switch s {
            case is StateProtocol:
                let region = IRegion()
                region.actionDispatcher = `internal`.region.actionDispatcher
                let iVertex = IVertex(
                    location: .init(superior: `internal`),
                    region: region,
                    external: s
                )
                s.internal = iVertex
                region.rootState = iVertex
                regions.append(region)
            case is ClusterProtocol:
                let region = IRegion()
                region.actionDispatcher = `internal`.region.actionDispatcher
                let iCluster = IRegionCluster(
                    location: .init(superior: `internal`),
                    region: region,
                    external: s,
                    subregions: []
                )
                s.internal = iCluster
                region.rootState = iCluster
                regions.append(region)
            case is ForkProtocol:
                let iFork = IFork(
                    location: .init(superior: `internal`),
                    region: `internal`.region, // use the region of the cluster itself
                    external: s,
                    outgoings: []
                )
                s.internal = iFork
            default: break
            }
            s.initialize()
        }
        (`internal` as! IRegionCluster).subregions = regions
    }
}
