//
//  Transition.swift
//  HSM
//
//  Created by Serhiy Butz on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

public struct Transition {
    // MARK: - Properties

    public let target: StateProtocol? /// `nil` indicates an *internal* self-transition
                                      /// and the same target as the source itself indicates an *external* self-transition
    public let action: (() -> Void)?

    // MARK: - Initialization

    public init(to target: StateProtocol? = nil, action: (() -> Void)? = nil) {
        self.target = target
        self.action = action
    }
}
