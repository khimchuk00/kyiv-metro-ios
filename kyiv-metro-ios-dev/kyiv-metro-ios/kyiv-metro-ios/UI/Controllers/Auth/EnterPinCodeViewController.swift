
import UIKit
import LocalAuthentication

class EnterPinCodeViewController: OffsetableViewController {
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var firstDigitTextField: KMTextField!
    @IBOutlet weak var secondDigitTextField: KMTextField!
    @IBOutlet weak var thirdDigitTextField: KMTextField!
    @IBOutlet weak var fourthDigitTextField: KMTextField!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var bioAuthButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override class var storyboard: Storyboard {
        return .auth
    }
    
    var phoneNumber = "1214567890"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerImageView.image = headerImageView.image?.alpha(0.1)
        configureTextField()
        configurePhoneNumber()
        configureBioAuth()
        configureButtons()
    }
    
    private func configureButtons() {
        backButton.touchAreaEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
        bioAuthButton.touchAreaEdgeInsets = UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20)
    }
    
    private func configureTextField() {
        firstDigitTextField.delegate = self
        firstDigitTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        secondDigitTextField.delegate = self
        secondDigitTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        thirdDigitTextField.delegate = self
        thirdDigitTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        fourthDigitTextField.delegate = self
        fourthDigitTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        firstDigitTextField.returnKeyType = .next
        secondDigitTextField.returnKeyType = .next
        thirdDigitTextField.returnKeyType = .next
        
        setupTextFieldBackwardActions()
    }
    
    private func configurePhoneNumber () {
        phoneNumber.removeFirst(8)
        phoneNumberLabel.text = "********" + phoneNumber
    }
    
    private func configureBioAuth() {
        let authContext = LAContext()
        authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .touchID:
            bioAuthButton.setImage(UIImage(named: "touch_id"), for: .normal)
        case .faceID:
            bioAuthButton.setImage(UIImage(named: "face-id-logo"), for: .normal)
        default:
            break
        }
    }
    
    private func loginAction() {
        let vc = ProfileViewController.instantiate().embededInNavigationController()
        showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(vc, animated: true)
            self.hideHUD()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func forgotButtonPressed() {
        
    }
    
    @IBAction func bioAuthButtonPressed() {
        let authContext = LAContext()
        var error: NSError?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Використовується для входу в акаунт за допомогою біометричних даних "
            authContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async { [weak self] in
                        self?.loginAction()
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                }
            }
        } else {
            print(error)
        }
    }
    
    @IBAction func logOutButtonPressed() {
        dismiss(animated: true)
    }
    
    private func setupTextFieldBackwardActions() {
        secondDigitTextField.deleteBackwardAction = {
            self.firstDigitTextField.becomeFirstResponder()
        }
        thirdDigitTextField.deleteBackwardAction = {
            self.secondDigitTextField.becomeFirstResponder()
        }
        fourthDigitTextField.deleteBackwardAction = {
            self.thirdDigitTextField.becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate

extension EnterPinCodeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case firstDigitTextField:
            secondDigitTextField.becomeFirstResponder()
        case secondDigitTextField:
            thirdDigitTextField.becomeFirstResponder()
        case thirdDigitTextField:
            fourthDigitTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if textField.text?.count == 1 {
            switch textField {
            case firstDigitTextField:
                secondDigitTextField.becomeFirstResponder()
            case secondDigitTextField:
                thirdDigitTextField.becomeFirstResponder()
            case thirdDigitTextField:
                fourthDigitTextField.becomeFirstResponder()
            case fourthDigitTextField:
                textField.resignFirstResponder()
                loginAction()
            default:
                break
            }
        }
    }
    
    func textField (_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text
            else {
                return true
        }
        let newLenght = text.count + string.count - range.length
        return newLenght <= 1
    }

}
