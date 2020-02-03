//
//  Cluster.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

open class Cluster<P: StateBasic, U: TopStateEventTypeProtocol>: Vertex<P, U>, ClusterProtocol {}

// MARK: - Traits

extension Cluster: BindingCluster {}
