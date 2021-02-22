

import UIKit

class GuideViewController: BaseViewController {
    
    override class var storyboard: Storyboard {
        return .guide
    }

    @IBOutlet weak var protectDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
    
    private func configureButton() {
        let atributtedText = NSAttributedString(string: "Безпека персональних даних", attributes: [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: Theme.Colors.themeGreen
        ])
        
        protectDataButton.setAttributedTitle(atributtedText, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func protectDataPressed() {
        
    }
    
    @IBAction func doneButtonPressed() {
        let vc = AuthViewController.instantiate()
        present(vc.embededInNavigationController(), animated: true)
    }
    
}
