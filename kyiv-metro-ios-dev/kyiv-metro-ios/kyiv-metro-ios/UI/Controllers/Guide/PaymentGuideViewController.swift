import UIKit

class PaymentGuideViewController: BaseViewController {
    
    override class var storyboard: Storyboard {
        return .guide
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationbar()
    }
    
    private func configureNavigationbar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func donePressed() {
        let vc = ProfileViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
}
