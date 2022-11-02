//
//  IStateTopology+traverse.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

extension IStateTopology {
    static func traverseFromRoot(to dst: IStateTopology, nextEntryState: IStateTopology? = nil, visit: (_ current: IStateTopology, _ next: IStateTopology?) -> Void) {
        if dst.location.nestingLevel > 0 {
            traverseFromRoot(to: dst.location.superior!, nextEntryState: dst, visit: visit)
        }
        visit(dst, nextEntryState)
    }

    // Traverse from `src` state to `dst` state, executing state `exitVisit`s (down the hierarcy) and `enterVisit`s (up the hierarcy) along the path.
    static func traverse(from src: IStateTopology, to dst: IStateTopology,
                         nextEntryState: IStateTopology? = nil, prevExitState: IStateTopology? = nil,
                         entryVisit: ((_ current: IStateTopology, _ next: IStateTopology?) -> Void)? = nil,
                         exitVisit: ((_ current: IStateTopology, _ prev: IStateTopology?) -> Void)? = nil,
                         // LCA visit
                         convergeVisit: ((_ current: IStateTopology, _ prev: IStateTopology?, _ next: IStateTopology?) -> Void)? = nil
    )
    {
        if src === dst {
            convergeVisit?(src, prevExitState, nextEntryState)
            return
        } else if src.location.nestingLevel > dst.location.nestingLevel {
            exitVisit?(src, prevExitState)
            traverse(from: src.location.superior!, to: dst, nextEntryState: nextEntryState, prevExitState: src, entryVisit: entryVisit, exitVisit: exitVisit, convergeVisit: convergeVisit)
        } else if dst.location.nestingLevel > src.location.nestingLevel {
            traverse(from: src, to: dst.location.superior!, nextEntryState: dst, prevExitState: prevExitState, entryVisit: entryVisit, exitVisit: exitVisit, convergeVisit: convergeVisit)
            entryVisit?(dst, nextEntryState)
        } else {
            exitVisit?(src, prevExitState)
            traverse(from: src.location.superior!, to: dst.location.superior!, nextEntryState: dst, prevExitState: src, entryVisit: entryVisit, exitVisit: exitVisit, convergeVisit: convergeVisit)
            entryVisit?(dst, nextEntryState)
        }
    }
}
