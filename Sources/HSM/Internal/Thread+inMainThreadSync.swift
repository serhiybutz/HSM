//
//  Thread+inMainThreadSync.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import Foundation

extension Thread {
    @discardableResult
    static func inMainThreadSync<T>(block: () -> T) -> T {
        var result: T
        if isMainThread {
            result = block()
        } else {
            result = DispatchQueue.main.sync(execute: block)
        }
        return result
    }
}
