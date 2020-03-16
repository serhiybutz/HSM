//
//  IRegionCluster.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

final class IRegionCluster: IStateBase {
    // MARK: - Properties

    var subregions: [IRegion]

    // MARK: - Initialization

    init(location: IStateTopologyLocation, region: IRegion, external: InternalReferencing, subregions: [IRegion]) {
        self.subregions = subregions
        super.init(location: location, region: region, external: external)
    }

    // MARK: - Lifecycle

    override func onActivation(next: IStateTopology?, _ context: ITransitionContext) {
        super.onActivation(next: nil, context)
        activateSubregions(next, context)
    }

    override func onDeactivation(_ context: ITransitionContext) {
        for subregion in subregions {
            subregion.activateState(nil, nonFinalTargetNext: nil, context)
        }
        super.onDeactivation(context)
    }

    // MARK: - Helpers

    func activateSubregions(_ next: IStateTopology?, _ context: ITransitionContext) {
        for subregion in subregions where next !== subregion.rootState && !subregion.skip {
            let dst = (subregion.rootState! as? IStateAttributes)?.promotedActivation ?? subregion.rootState!
            subregion.activateState(dst, nonFinalTargetNext: nil, context)
        }
    }

    static func execSkippingSubregionActivationFor(_ regions: [IRegion], exec: () -> Void) {
        regions.forEach { $0.skip = true }
        defer { regions.forEach { $0.skip = false } }
        exec()
    }
}
