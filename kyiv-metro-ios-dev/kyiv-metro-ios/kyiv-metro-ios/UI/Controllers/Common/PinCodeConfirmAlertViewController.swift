

import UIKit

class PinCodeConfirmAlertViewController: OffsetableViewController {
    
    override class var storyboard: Storyboard {
        return .common
    }
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var firstDigitTextField: KMTextField!
    @IBOutlet weak var secondDigitTextField: KMTextField!
    @IBOutlet weak var thirdDigitTextField: KMTextField!
    @IBOutlet weak var fourthDigitTextField: KMTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var correctPincode: String = ""
    
    var confirmAction: ((Bool) -> Void)?
    var cancelAction: (() -> Void)?
    
    static func instantiate(pinCode: String) -> PinCodeConfirmAlertViewController {
        let vc = PinCodeConfirmAlertViewController.instantiate()
        vc.correctPincode = pinCode
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    
    override func offsetableTextFields() -> [UITextField] {
        return [firstDigitTextField, secondDigitTextField, thirdDigitTextField, fourthDigitTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        confirmButton.isEnabled = false
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
    
    override func viewDidLayoutSubviews() {
        configureContainer()
    }
    
    private func configureContainer() {
        containerView.layer.cornerRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shouldRasterize = true
    }
    
    private func getPincode() -> String {
        let first = firstDigitTextField.text ?? ""
        let second = secondDigitTextField.text ?? ""
        let third = thirdDigitTextField.text ?? ""
        let fourth = fourthDigitTextField.text ?? ""
        
        return first + second + third + fourth
    }
    
    // MARK: - Actions
    
    @IBAction func cancelPressed() {
        dismiss(animated: false) {
            self.cancelAction?()
        }
    }
    
    @IBAction func confirmPressed() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.confirmAction?(self.getPincode() == self.correctPincode)
        }
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

extension PinCodeConfirmAlertViewController: UITextFieldDelegate {
    
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
        if text.count == 1 {
            switch textField {
            case firstDigitTextField:
                secondDigitTextField.becomeFirstResponder()
            case secondDigitTextField:
                thirdDigitTextField.becomeFirstResponder()
            case thirdDigitTextField:
                fourthDigitTextField.becomeFirstResponder()
            case thirdDigitTextField:
                fourthDigitTextField.resignFirstResponder()
            default:
                break
            }
        }
        confirmButton.isEnabled = getPincode().count == 4
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
