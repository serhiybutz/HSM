//
//  ITransitionContext.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

final class ITransitionContext {
    var triggeredTransitions: IUniqueRegionTransitions = []
    var transitionAction: (() -> Void)?
}
