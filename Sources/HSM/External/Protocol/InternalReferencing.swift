//
//  InternalReferencing.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

protocol InternalReferencing: AnyObject {
    var `internal`: IStateBase! { get set }
}
