//
//  IFork.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

final class IFork: IStateBase {
    // MARK: - Properties

    var outgoings: [IStateBase]!

    // MARK: - Initialization

    init(location: IStateTopologyLocation, region: IRegion, external: InternalReferencing, outgoings: [IStateBase]) {
        self.outgoings = outgoings
        super.init(location: location, region: region, external: external)
    }
}
