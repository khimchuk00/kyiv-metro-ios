
import UIKit
import JGProgressHUD

protocol StoryboardInstantiableVC: class {}

extension StoryboardInstantiableVC where Self: BaseViewController {
    static func instantiate() -> Self {
        let vc: Self = storyboard.instantiate()
        return vc
    }
}

extension UIViewController: StoryboardInstantiableVC {}

class BaseViewController: UIViewController {
    
    class var storyboard: Storyboard {
        return .main
    }
    
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    var actionHud: JGProgressHUD?
    
    var hudContainerView: UIView? {
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = Theme.Colors.themeGreen
    }
    
    func embededInNavigationController() -> KMNavigationViewController {
        let navigationVC = KMNavigationViewController(rootViewController: self)
        navigationVC.modalPresentationStyle = .fullScreen
        return navigationVC
    }
    
    // MARK: - HUD
    
    func showHUD(message: String? = nil) {
        view.isUserInteractionEnabled = false
        actionHud = Theme.showHudProgress(in: self.hudContainerView ?? view, msg: message)
    }
    
    func hideHUD() {
        view.isUserInteractionEnabled = true
        if let hud = actionHud {
            hud.dismiss(animated: false)
        }
    }
    
}
