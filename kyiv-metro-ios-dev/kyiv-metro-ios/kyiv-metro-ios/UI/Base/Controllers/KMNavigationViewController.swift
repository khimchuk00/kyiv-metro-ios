

import UIKit

class KMNavigationViewController: UINavigationController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }
    
    func configure() {
        navigationItem.leftBarButtonItem?.tintColor = Theme.Colors.themeGreen
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = Theme.Colors.themeWhite
        navigationBar.isTranslucent = true
        modalPresentationStyle = .fullScreen
    }
    
    func setBackButton(title: String) {
        let backButton = UIButton(type: .custom)
        backButton.setTitle(title, for: .normal)
        let backItem = UIBarButtonItem(customView: backButton)
        navigationItem.backBarButtonItem = backItem
    }
}
