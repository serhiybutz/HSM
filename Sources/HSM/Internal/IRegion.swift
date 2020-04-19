//
//  IRegion.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

final class IRegion {
    // MARK: - Properties

    var skip: Bool = false

    var rootState: IStateBase?

    private(set) var activeState: IStateBase? {
        didSet {
#if DebugVerbosityLevel2
            if activeState !== oldValue {
                os_log("### [%s:%s] Active state: %s -> %s", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", String(describing: oldValue), String(describing: activeState))
            }
#endif
        }
    }

    // MARK: - Methods

    func transition(to target: IStateTopology?, context: ITransitionContext! = ITransitionContext()) {
        defer {
            if let action = context.transitionAction {
                action()
                context.transitionAction = nil
            }
        }

        guard let target = target else { return }

        if activeState === target && !(target is IRegionCluster) {
            // edge case for external self transition
            (target as! IStateBase).onDeactivation(context)
            if let action = context.transitionAction {
                action()
                context.transitionAction = nil
            }
            (target as! IStateBase).onActivation(next: nil, context)
        } else {
            // address the dynamic mechanism of state transition
            let finalTarget = (target as? IStateAttributes)?.promotedActivation ?? target

            IStateBase.traverseFromRoot(to: finalTarget) { current, next in
                let currentState = (current as! IStateBase)
                if currentState is IRegionCluster {
                    currentState.region.activateState(current, nonFinalTargetNext: next, context)
                } else if currentState === finalTarget {
                    currentState.region.activateState(current, nonFinalTargetNext: next, context)
                }
            }
        }

        handleTriggeredTransitions(context)
    }

    func activateState(_ state: IStateTopology?, nonFinalTargetNext: IStateTopology?, _ context: ITransitionContext) {
        if let state = state {
            precondition(state.region === self)

            let actState = activeState ?? rootState!
            IStateBase.traverse(
                from: actState,
                to: state,
                entryVisit: { current, inRegionNext in
                    if let action = context.transitionAction {
                        action()
                        context.transitionAction = nil
                    }
                    (current as! IStateBase).onActivation(next: inRegionNext ?? nonFinalTargetNext, context)
                },
                exitVisit: { current, prev in
                    (current as! IStateBase).onDeactivation(context)
                },
                convergeVisit: { current, _, inRegionNext in
                    if self.activeState == nil {
                        // when the region is not yet attended, we need to activate the original (root) state
                        (current as! IStateBase).onActivation(next: inRegionNext ?? nonFinalTargetNext, context)
                    }
                }
            )
            (state as! IStateBase).handleTriggers(context)
        } else {
            // deactivate the whole region
            guard activeState != nil else { return }

            var runningState: IStateBase? = activeState!
            while runningState != nil {
                runningState!.onDeactivation(context)
                runningState = runningState!.superiorInRegion as! IStateBase?
            }
        }
        self.activeState = state as! IStateBase?
        if let activeState = activeState {
            preserveHistoryConfiguration(deepest: activeState)
        }
    }

    func isStateActive(_ state: IStateBase) -> Bool {
        var runningActiveState: IStateBase? = activeState
        while runningActiveState != nil {
            if runningActiveState === state { return true }
            runningActiveState = runningActiveState!.superiorInRegion as! IStateBase?
        }
        return false
    }

    func preserveHistoryConfiguration(deepest: IStateBase) {
        var runningActiveState: IStateBase! = activeState
        while runningActiveState != nil {
            (runningActiveState as? IStateAttributes)?.preserveHistoricStateIfNeeded(deepest: deepest)
            runningActiveState = runningActiveState!.superiorInRegion as! IStateBase?
        }
    }

    func handleTriggeredTransitions(_ context: ITransitionContext) {
        while !context.triggeredTransitions.isEmpty {
            let triggeredTransitions = context.triggeredTransitions
            context.triggeredTransitions = []
            IRegionCluster.execSkippingSubregionActivationFor(triggeredTransitions.map { $0.source.region }) {
                for triggered in triggeredTransitions {
                    let target = (triggered.transition.target as! InternalReferencing).internal!
                    triggered.source.transition(to: target, action: triggered.transition.action)
                }
            }
        }
    }

    func dispatch(_ event: EventProtocol, _ transitions: IUniqueRegionTransitions) {
        traverseActive { currentState in
            if let transition = (currentState.external as? DowncastingEventHandling)?._handle(event) {
                transitions.register(transition, for: currentState)
                return true
            } else {
                return false
            }
        }
    }

    func activeStateConfiguration() -> [IStateBase] {
        var result: [IStateBase] = []
        traverseActive { currentState in
            result.append(currentState)
            return true
        }
        return result
    }

    func traverseActive(_ exec: (IStateBase) -> Bool) {
        guard let activeState = activeState else { return }
        var runningState: IStateBase? = activeState
        if let regionCluster = runningState as? IRegionCluster {
            for subregion in regionCluster.subregions {
                subregion.traverseActive(exec)
            }
        } else {
            while runningState != nil {
                precondition(!(runningState is IRegionCluster))
                if exec(runningState!) { return }
                runningState = runningState!.superiorInRegion as! IStateBase?
            }
        }
    }
}

// MARK: - Debugging-related

extension IRegion: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        "\(type(of: self))(\(String(format: "%p", unsafeBitCast(self, to: Int.self))))"
    }
    public var debugDescription: String { description }
    public func activeStateConfigDump() -> String {
        activeStateConfiguration()
            .map { $0.description }
            .joined(separator: "\n")
    }
}
