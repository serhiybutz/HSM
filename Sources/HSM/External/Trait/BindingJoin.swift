//
//  BindingJoin.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

public protocol BindingJoin: StateBasic {
    associatedtype TopStateType: TopStateEventTypeProtocol
    associatedtype SuperiorType: StateBasic
    var top: TopStateType { get }
    var superior: SuperiorType { get }
}

extension BindingJoin {
    public func bindIncomings(_ incomings: BaseState<TopStateType>...) {
        let iJoin = (self as! InternalReferencing).internal as! IJoin
        iJoin.incomings = incomings.map { $0.internal! }
        setupJoin(iJoin, for: incomings)
    }

    func setupJoin(_ iJoin: IJoin, for incomings: [BaseState<TopStateType>]) {
        incomings.forEach {
            let iState = $0.internal!
            if iState.fork != nil {
                os_log("### [%s:%s] State \"%s\" shares both joins and a fork!", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(iState)")
            }
            iState.addJoin(iJoin)
        }
    }
}
