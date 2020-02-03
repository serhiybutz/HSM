//
//  IStateTopology.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

protocol IStateTopology: AnyObject {
    var location: IStateTopologyLocation { get }
    var region: IRegion { get }
    var external: InternalReferencing { get }
    var superiorInRegion: IStateTopology? { get }
}
