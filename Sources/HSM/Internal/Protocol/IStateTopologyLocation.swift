//
//  IStateTopologyLocation.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

struct IStateTopologyLocation {
    enum Location {
        case root
        case nested(level: Int, superior: IStateTopology)
    }
    let value: Location
    init() {
        value = .root
    }
    init(superior: IStateTopology) {
        value = .nested(level: superior.location.nestingLevel + 1, superior: superior)
    }
    var nestingLevel: Int {
        switch value {
        case .root: return 0
        case .nested(let level, _): return level
        }
    }
    var superior: IStateTopology? {
        switch value {
        case .root: return nil
        case .nested(_, let superior): return superior
        }
    }
}
