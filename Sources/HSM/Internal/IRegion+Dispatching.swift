//
//  IRegion+Dispatching.swift
//  HSM
//
//  Created by Serge Bouts on 4/14/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

// MARK: - Dispatching

extension IRegion: Dispatching {
    func start() {
        (rootState!.external as! StateBasic).initialize()
        transition(to: rootState)
    }

    func dispatch(_ event: EventProtocol, completion: DispatchCompletion?) {
        let transitions = IUniqueRegionEntries<ITransition>()
        dispatch(event, transitions)
        let isConsumed = !transitions.isEmpty
        if isConsumed {
            for iTran in transitions {
                let target = (iTran.transition.target as! InternalReferencing).internal!
                iTran.source.transition(to: target, action: iTran.transition.action)
            }
        } else {
            precondition(transitions.isEmpty)
#if DebugVerbosityLevel1 || DebugVerbosityLevel2
            os_log("### [%s:%s] Transition has not been handled for event %s: %s", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)", activeStateConfigDump())
#endif
        }
        completion?(isConsumed)
    }
}
