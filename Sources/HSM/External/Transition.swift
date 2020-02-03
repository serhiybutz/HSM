//
//  Transition.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public struct Transition {
    // MARK: - Properties

    public let target: StateProtocol? // `nil` indicates an internal transition
    public let action: (() -> Void)?

    // MARK: - Initialization

    public init(to target: StateProtocol? = nil, action: (() -> Void)? = nil) {
        self.target = target
        self.action = action
    }
}
