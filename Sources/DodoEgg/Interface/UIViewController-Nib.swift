// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

extension UIViewController {
    public static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            // Separating by < so we can catch generic implementations i.e. AddCardViewController<Treasure>
            return T.init(nibName: String(describing: T.self).components(separatedBy: "<")[0], bundle: nil)
        }

        return instantiateFromNib()
    }
}
