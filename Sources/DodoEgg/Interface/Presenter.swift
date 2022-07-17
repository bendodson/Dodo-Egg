// Developed by Ben Dodson (ben@bendodson.com)

import UIKit

public protocol Presenter {
    func instance() -> UIViewController
    func instanceInNavigationController() -> UINavigationController
    func present(from viewController: UIViewController)
}

extension Presenter {
    public func instanceInNavigationController() -> UINavigationController {
        return BaseNavigationController(rootViewController: instance())
    }
    
    public func present(from viewController: UIViewController) {
        viewController.navigationController?.pushViewController(instance(), animated: true)
    }
}

