//
//  Join.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

open class Join<P: StateBasic, U: TopStateEventTypeProtocol>: Vertex<P, U>, JoinProtocol {}

// MARK: - Traits

extension Join: BindingJoin {}
