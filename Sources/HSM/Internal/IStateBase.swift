//
//  IStateBase.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

class IStateBase: IStateTopology {
    // MARK: - IStateTopology

    let location: IStateTopologyLocation
    unowned let region: IRegion
    unowned let external: InternalReferencing // external representation

    var fork: IFork?
    var joins: [IJoin]?

    // MARK: - Initialization

    init(location: IStateTopologyLocation, region: IRegion, external: InternalReferencing) {
        self.location = location
        self.region = region
        self.external = external
    }

    // MARK: - UI

    var isActive: Bool { region.isStateActive(self) }

    var superiorInRegion: IStateTopology? {
        region.rootState === self
            ? nil
            : location.superior
    }

    func addJoin(_ join: IJoin) {
        if joins == nil {
            joins = []
        }
        joins?.append(join)
    }

    func transition(to target: IStateBase, action: (() -> Void)?) {
        let context = ITransitionContext()
        context.transitionAction = action
        region.transition(to: target, context: context)
    }

    // MARK: - Lifecycle

    func onActivation(next: IStateTopology?, _ context: ITransitionContext) {
        if let entryAction = (external as? StateProtocol)?.entry {
            region.actionDispatcher.dispatch(entryAction)
        }
        // Signal joins
        if let joins = joins {
            for join in joins {
                var isTriggerred = true
                for incoming in join.incomings where incoming !== self {
                    if !incoming.isActive {
                        isTriggerred = false
                        break
                    }
                }
                if isTriggerred {
                    let state = join.superiorInRegion! as! IStateBase
                    context.triggeredActivations.append(state.region, payload: state)
                }
            }
        }
        if let fork = fork {
            for outgoing in fork.outgoings {
                context.triggeredActivations.append(outgoing.region, payload: outgoing)
            }
        }
    }

    func onDeactivation(_ context: ITransitionContext) {
        if let exitAction = (external as? StateProtocol)?.exit {
            region.actionDispatcher.dispatch(exitAction)
        }
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible
extension IStateBase: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let `internal` = self as AnyObject
        let region = self.region as AnyObject
        let external = self.external as AnyObject
        return "\(type(of: `internal`))(\(String(format: "%p", unsafeBitCast(`internal`, to: Int.self))))^\(type(of: region))(\(String(format: "%p", unsafeBitCast(region, to: Int.self)))){\(breadCrumbs)(\(String(format: "%p", unsafeBitCast(external, to: Int.self))))}"
    }
    public var debugDescription: String { description }
    public var breadCrumbs: String {
        let str = "\(type(of: external))"
        if let s = location.superior {
            return "\((s as! IStateBase).breadCrumbs)/\(str)"
        } else {
            return str
        }
    }
}
