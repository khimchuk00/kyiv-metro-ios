
import UIKit

class MetroMapSchemeViewController: BaseViewController {
    
    override class var storyboard: Storyboard {
        return .profile
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavigationBarConfigurations()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Карта метро"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = "Профіль"
    }
    
    private func resetNavigationBarConfigurations() {
        navigationItem.title = ""
        navigationController?.isNavigationBarHidden = true
    }
}
