// Developed by Ben Dodson (ben@bendodson.com)

import Foundation

extension Array {
    /// Split an array into an array of arrays limited by size
    public func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
