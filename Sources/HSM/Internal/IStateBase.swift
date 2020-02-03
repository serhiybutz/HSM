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

    func dispatch(_ event: EventProtocol, _ transitions: IUniqueRegionEntries<ITransition>) -> Bool {
        if let transition = (external as? DowncastingEventHandling)?._handle(event) {
            if let targetState = (transition.target as! InternalReferencing?)?.internal {
                transitions.append(targetState.region, payload: ITransition(source: self, transition: transition))
            } else {
                // perform action for internal transition in place and consider the dispatch handled in this region
                if let action = transition.action {
                    region.actionDispatcher.dispatch(action)
                }
            }
            return true // dispatch has been handled
        } else {
            return false
        }
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible
extension IStateBase: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        let `internal` = self as AnyObject
        let region = self.region as AnyObject
        let external = self.external as AnyObject
        return "\(type(of: `internal`))(\(String(format: "%p", unsafeBitCast(`internal`, to: Int.self)))){\(type(of: region))(\(String(format: "%p", unsafeBitCast(region, to: Int.self))))}{\(type(of: external))(\(String(format: "%p", unsafeBitCast(external, to: Int.self))))}"
    }
    public var debugDescription: String { description }
}
