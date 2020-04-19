//
//  IUniqueRegionTransitions.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

final class IUniqueRegionTransitions {
    // MARK: - Properties

    var entries: ContiguousArray<ITransition> = []
    var uniqueRegion: Set<Int> = []
    func append(_ region: IRegion?, payload: ITransition) {
        let rid = unsafeBitCast(region, to: Int.self)
        guard !uniqueRegion.contains(rid) else {
#if DebugVerbosityLevel1 || DebugVerbosityLevel2
            os_log("### [%s:%s] Multiple entries in same region attempted: %s! Skipping...", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(payload)")
#endif
            return
        }
        uniqueRegion.insert(rid)
        entries.append(payload)
    }

    func register(_ transition: Transition, for currentState: IStateBase) {
        if let target = transition.target {
            // External transition:
            let targetState = (target as! InternalReferencing).internal!
            append(targetState.region, payload: ITransition(source: currentState, transition: transition))
        } else {
            append(nil, payload: ITransition(source: currentState, transition: transition))
        }
    }
}

// MARK: - Collection

extension IUniqueRegionTransitions: Collection {
    func index(after idx: Int) -> Int { entries.index(after: idx) }
    var startIndex: Int { entries.startIndex }
    public var endIndex: Int { entries.endIndex }
    subscript(idx: Int) -> ITransition {
        get { entries[idx] }
        set { entries[idx] = newValue }
    }
}

// MARK: - ExpressibleByArrayLiteral

extension IUniqueRegionTransitions: ExpressibleByArrayLiteral {
    convenience init(arrayLiteral elements: (IRegion, ITransition)...) {
        self.init()
        elements.forEach { append($0.0, payload: $0.1) }
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension IUniqueRegionTransitions: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return entries.description
    }
    public var debugDescription: String {
        return entries.description
    }
}
