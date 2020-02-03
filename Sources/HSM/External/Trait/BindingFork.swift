//
//  BindingFork.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

public protocol BindingFork: StateBasic {
    associatedtype TopStateType: TopStateEventTypeProtocol
    associatedtype SuperiorType: StateBasic
    var top: TopStateType { get }
    var superior: SuperiorType { get }
}

extension BindingFork {
    public func bindOutgoings(_ outgoings: BaseState<TopStateType>...) {
        let iFork = ((self as! InternalReferencing).internal as! IFork)
        iFork.outgoings = outgoings.map { $0.internal! }
        setFork(iFork)
    }
    func setFork(_ iFork: IFork) {
        let superiorState = (iFork.superiorInRegion! as! IStateBase)
        if superiorState.fork != nil {
            os_log("### [%s:%s] State \"%s\" with multiple forks!", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(superiorState)")
        }
        if superiorState.joins != nil {
            os_log("### [%s:%s] State \"%s\" shares both joins and a fork!", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(superiorState)")
        }
        superiorState.fork = iFork
    }
}
