public protocol StateQueries {
    var superiorState: StateBasic? { get }
    var representsRegion: Bool { get }
    var activeStateInRegion: StateBasic? { get }
}
