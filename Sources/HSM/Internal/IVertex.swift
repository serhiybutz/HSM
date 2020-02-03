//
//  IVertex.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

class IVertex: IStateBase, IStateAttributes {
    // MARK: - IStateAttributes

    var initial: IStateBase?
    var historyMode: HistoryMode = .none
    var historyDst: IStateBase?

    var promotedActivation: IStateBase {
        if let dst = historyDst ?? initial {
            if let saDst = dst as? IStateAttributes {
                return saDst.promotedActivation
            } else {
                return dst
            }
        } else {
            return self
        }
    }

    func preserveHistoricStateIfNeeded(deepest: IStateBase) {
        if case .deep = historyMode {
            historyDst = deepest
        }
        if let superior = superiorInRegion,
           let saState = superior as? IStateAttributes
        {
            if case .shallow = saState.historyMode {
                saState.historyDst = self
            }
        }
    }
}
