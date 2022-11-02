//
//  IStateAttributes.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

protocol IStateAttributes: AnyObject {
    var initial: IStateBase? { get set }
    var historyMode: HistoryMode { get set }
    var historyDst: IStateBase? { get set }
    var promotedActivation: IStateBase { get }
    func preserveHistoricStateIfNeeded(deepest: IStateBase)
}
