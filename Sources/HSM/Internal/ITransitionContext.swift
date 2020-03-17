//
//  ITransitionContext.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

final class ITransitionContext {
    var triggeredTransitions: IUniqueRegionEntries<ITransition> = []
    var transitionAction: (() -> Void)?
}
