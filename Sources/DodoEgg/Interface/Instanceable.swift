// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

public protocol Instanceable {
}

extension Instanceable {
    public static func instance() -> Self {
        let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}
