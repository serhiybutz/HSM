//
//  IRegion+Dispatching.swift
//  HSM
//
//  Created by Serhiy Butz on 4/14/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

// MARK: - Dispatching

extension IRegion: Dispatching {
    func start() {
        (rootState!.external as! StateBasic).initialize()
        transition(to: rootState)
    }

    func dispatch(_ event: EventProtocol) -> Bool {
        let transitions = IUniqueRegionTransitions()
        dispatch(event, transitions)
        let isConsumed = !transitions.isEmpty
        if isConsumed {
            for iTran in transitions {
                if let target = (iTran.transition.target.flatMap({ $0 as? InternalReferencing }))?.internal! {
                    iTran.source.transition(to: target, action: iTran.transition.action)
                } else {
                    // Perform action for internal transition
                    if let action = iTran.transition.action {
                        action()
                    }
                }
            }
        } else {
            precondition(transitions.isEmpty)
#if DebugVerbosityLevel1 || DebugVerbosityLevel2
            os_log("### [%s:%s] Transition has not been handled for event %s: %s", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)", activeStateConfigDump())
#endif
        }
        return isConsumed
    }
}
