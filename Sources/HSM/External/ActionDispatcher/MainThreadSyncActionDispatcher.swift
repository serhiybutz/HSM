//
//  MainThreadSyncActionDispatcher.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

public struct MainThreadSyncActionDispatcher: ActionDispatching {
    @discardableResult
    public func dispatch<T>(_ action: () -> T) -> T {
        Thread.inMainThreadSync(block: action)
    }
}
