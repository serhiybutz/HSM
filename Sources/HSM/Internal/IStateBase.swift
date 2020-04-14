//
//  IStateBase.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation
import os.log

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
        (external as? StateProtocol)?.entry()
    }

    func handleTriggers(_ context: ITransitionContext) {
        var isUsed = false
        // (1) Try joins
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
                    context.triggeredTransitions.append(state.region, payload: ITransition(source: state, transition: Transition(to: (state.external as! StateProtocol))))
                }
            }
            isUsed = true
        }
        /// (2) Try forks
        if let fork = fork, !fork.outgoings.isEmpty {
            if isUsed {
                os_log("### [%s:%s] State \"%s\" with multiple reaction types!", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(self)")
                return
            }
            for outgoing in fork.outgoings {
                context.triggeredTransitions.append(outgoing.region, payload: ITransition(source: outgoing, transition: Transition(to: (outgoing.external as! StateProtocol))))
            }
            isUsed = true
        }
        /// (3) Try *always* reaction
        if let transition = (external as? StateProtocol)?.always() {
            if isUsed {
                os_log("### [%s:%s] State \"%s\" with multiple reaction types!", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(self)")
                return
            }
            context.triggeredTransitions.append((transition.target as! InternalReferencing).internal.region,
                                                payload: ITransition(source: self, transition: transition))
            isUsed = true
        }
    }

    func onDeactivation(_ context: ITransitionContext) {
        (external as? StateProtocol)?.exit()
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
            return "\((s as! IStateBase).breadCrumbs).\(str)"
        } else {
            return str
        }
    }
}
