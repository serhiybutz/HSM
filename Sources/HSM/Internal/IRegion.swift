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

    var actionDispatcher: ActionDispatching!

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
                actionDispatcher.dispatch(action)
                context.transitionAction = nil
            }
        }

        guard let target = target else { return }

        if activeState === target && !(target is IRegionCluster) {
            // edge case for external self transition
            (target as! IStateBase).onDeactivation(context)
            if let action = context.transitionAction {
                self.actionDispatcher.dispatch(action)
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

        handleSubsequentTransitions(context)
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
                        self.actionDispatcher.dispatch(action)
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

    func handleSubsequentTransitions(_ context: ITransitionContext) {
        while !context.triggeredActivations.isEmpty {
            let triggeredActivations = context.triggeredActivations
            context.triggeredActivations = []
            IRegionCluster.execSkippingSubregionActivationFor(triggeredActivations.map { $0.region }) {
                for targetState in triggeredActivations {
                    targetState.region.transition(to: targetState as IStateTopology)
                }
            }
        }
    }

    func dispatch(_ event: EventProtocol, _ transitions: IUniqueRegionEntries<ITransition>) {
        traverseActive { currentState in
            if let transition = (currentState.external as? DowncastingEventHandling)?._handle(event) {
                if let target = transition.target {
                    // External transition:
                    let targetState = (target as! InternalReferencing).internal!
                    transitions.append(targetState.region, payload: ITransition(source: currentState, transition: transition))
                } else {
                    // Internal transition:
                    // Perform action for internal transition in place and consider the dispatch handled in this region
                    if let action = transition.action {
                        currentState.region.actionDispatcher.dispatch(action)
                    }
                }
                return true // dispatch has been handled
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
                if exec(runningState!) { return }
                runningState = runningState!.superiorInRegion as! IStateBase?
            }
        }
    }
}

// MARK: - Dispatching

extension IRegion: Dispatching {
    func dispatch(_ event: EventProtocol) {
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
            os_log("### [%s:%s] Transition has not been handled for event %s", log: .default, type: .debug, "\(ModuleName)", "\(type(of: self))", "\(event)")
#endif
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
