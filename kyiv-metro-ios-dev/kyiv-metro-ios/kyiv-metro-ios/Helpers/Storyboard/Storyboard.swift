
import UIKit

enum Storyboard {
    
    case main
    case auth
    case guide
    case pinCode
    case photo
    case card
    case profile
    case common
  
    private var name: String {
        switch self {
        case .main:
            return "Main"
        case .auth:
            return "Auth"
        case .guide:
            return "Guide"
        case .pinCode:
            return "PinCode"
        case .photo:
            return "Photo"
        case .card:
            return "Card"
        case .profile:
            return "Profile"
        case .common:
            return "Common"
        }
    }
    
    func getStroryboard() -> UIStoryboard {
        return UIStoryboard(name: name, bundle: Bundle.main)
    }
    
    func initialVC() -> UIViewController {
        guard let vc = getStroryboard().instantiateInitialViewController() else {
            fatalError("No initial view controller for \(self.name) storyboard")
        }
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func initialVC<T: UIViewController>(withType: T) -> T {
        guard let vc = initialVC() as? T else {
            fatalError("Initial view controller for \(self.name) storyboard can't be convertated to \(T.self)")
        }
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    func instantiate<T: BaseViewController>() -> T {
        guard let vc = getStroryboard().instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Can't instantiate \(T.self) from \(self.name) storyboard")
        }
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
}
