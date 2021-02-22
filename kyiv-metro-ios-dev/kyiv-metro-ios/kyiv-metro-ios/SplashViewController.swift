

import UIKit

var isLoggined = false

class SplashViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc: UIViewController!
        if isLoggined {
            vc = ProfileViewController.instantiate().embededInNavigationController()
        } else {
            vc = GuideViewController.instantiate()
        }
        present(vc, animated: true)
    }


}

