//
//  IUniqueRegionEntries.swift
//  HSM
//
//  Created by Serge Bouts on 2/01/20.
//  Copyright © 2020 iRiZen.com. All rights reserved.
//

import os.log

final class IUniqueRegionEntries<T> {
    // MARK: - Properties

    var entries: ContiguousArray<T> = []
    var uniqueRegion: Set<ObjectIdentifier> = []
    func append(_ region: IRegion, payload: T) {
        guard !uniqueRegion.contains(ObjectIdentifier(region)) else {
#if DebugVerbosityLevel1 || DebugVerbosityLevel2
            os_log("### [%s:%s] Multiple entries in same region attempted: %s! Skipping...", log: .default, type: .error, "\(ModuleName)", "\(type(of: self))", "\(payload)")
#endif
            return
        }
        uniqueRegion.insert(ObjectIdentifier(region))
        entries.append(payload)
    }
}

// MARK: - Collection

extension IUniqueRegionEntries: Collection {
    func index(after idx: Int) -> Int { entries.index(after: idx) }
    var startIndex: Int { entries.startIndex }
    public var endIndex: Int { entries.endIndex }
    subscript(idx: Int) -> T {
        get { entries[idx] }
        set { entries[idx] = newValue }
    }
}

// MARK: - Equatable

extension IUniqueRegionEntries: Equatable where T: AnyObject & Equatable {
    static func == (lhs: IUniqueRegionEntries, rhs: IUniqueRegionEntries) -> Bool { lhs.entries.elementsEqual(rhs.entries, by: === ) }
}

extension IUniqueRegionEntries where T: Equatable {
    static func == (lhs: IUniqueRegionEntries, rhs: IUniqueRegionEntries) -> Bool { lhs.entries.elementsEqual(rhs.entries, by: == ) }
}

// MARK: - ExpressibleByArrayLiteral

extension IUniqueRegionEntries: ExpressibleByArrayLiteral {
    convenience init(arrayLiteral elements: (IRegion, T)...) {
        self.init()
        elements.forEach { append($0.0, payload: $0.1) }
    }
}

// MARK: - CustomStringConvertible, CustomDebugStringConvertible

extension IUniqueRegionEntries: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return entries.description
    }
    public var debugDescription: String {
        return entries.description
    }
}
