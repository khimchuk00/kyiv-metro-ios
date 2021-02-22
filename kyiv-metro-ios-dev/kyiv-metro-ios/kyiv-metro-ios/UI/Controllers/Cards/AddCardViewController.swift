
import UIKit

class AddCardViewController: OffsetableViewController {
    
    override class var storyboard: Storyboard {
        return .card
    }
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cardTypeImage: UIImageView!
    @IBOutlet weak var privacyPolice: UILabel!
    
    var isFromRegistration: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        addButton.isEnabled = false
        setupPrivacyPolice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    
    private func configureTextField() {
        cardNumberTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        dateTextField.delegate = self
        dateTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cvvTextField.delegate = self
        cvvTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        cardNumberTextField.returnKeyType = .next
        dateTextField.returnKeyType = .next
        
    }
    
    private func configureNavigationBar() {
        if isFromRegistration {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.backItem?.title = "Назад"
        }
    }
    
    private func setupAddButton(enabled: Bool) {
        addButton.isEnabled = enabled
    }
    
    private func setupPrivacyPolice() {
        let attrTitle = NSMutableAttributedString(string: "Натискаючи на кнопку ", attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont()
        ])
        
        attrTitle.append(NSAttributedString(string: "Додати ", attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont(mode: .semibold)
        ]))
        
        attrTitle.append(NSAttributedString(string: "ви погоджуєтесь з ", attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont()
        ]))
        
        attrTitle.append(NSAttributedString(string: "Умовами використання MasterPass", attributes: [
            .foregroundColor: Theme.Colors.themeGreen,
            .font: Theme.Fonts.themeFont()
        ]))
        
        privacyPolice.attributedText = attrTitle
        let tap = UITapGestureRecognizer(target: self, action: #selector(privacyPolicePressed))
        privacyPolice.addGestureRecognizer(tap)
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed() {
        showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.hideHUD()
            let vc = PhotoGuideViewController.instantiate()
            vc.isFromRegistration = self.isFromRegistration
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func privacyPolicePressed() {
        
    }
}

// MARK: - UITextFieldDelegate

extension AddCardViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case cardNumberTextField:
            dateTextField.becomeFirstResponder()
        case dateTextField:
            cvvTextField.becomeFirstResponder()
        default:
            break
        }
        return true
    }
    
    @objc func textFieldChanged(_ textField: UITextField) {
        guard var text = textField.text else {
            setupAddButton(enabled: false)
            return
        }
        switch textField {
        case cardNumberTextField:
            text = modifiedCardNumber(from: text)
            if text.count == 1 {
                let imgName: String
                imgName = text.first == "4" ? "" : "mastercard"
                DispatchQueue.main.async {
                    self.cardTypeImage.image = UIImage(named: imgName)
                }
            }
        case dateTextField:
            text = modifiedDate(from: text)
        default:
            break
        }
        textField.text = text
        checkValid()
    }
    
    func textField (_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text
            else {
                return true
        }
        let newLenght = text.count + string.count - range.length
        switch textField {
        case cardNumberTextField:
            return newLenght <= 25
        case dateTextField:
            return newLenght <= 5
        case cvvTextField:
            return newLenght <= 3
        default:
            return newLenght <= 0
        }
        
    }
    
    private func modifiedCardNumber(from cardNumber: String) -> String {
        let arrOfCharacters = Array(cardNumber.replacingOccurrences(of: " - ", with: ""))
        var modifiedCodeString = ""
        
        if arrOfCharacters.count > 0 {
            for i in 0...arrOfCharacters.count - 1 {
                modifiedCodeString.append(arrOfCharacters[i])
                if [3, 7, 11].contains(i) && i + 1 != arrOfCharacters.count {
                    modifiedCodeString.append(" - ")
                }
            }
        }
        
        return modifiedCodeString
    }
    
    private func modifiedDate(from date: String) -> String {
        var arrOfCharacters = Array(date.replacingOccurrences(of: "/", with: ""))
        var modifiedCodeString = ""
        if arrOfCharacters.count > 0 {
            if !["0", "1"].contains(arrOfCharacters[0]) {
                arrOfCharacters.insert("0", at: 0)
            }
            for i in 0...arrOfCharacters.count - 1 {
                modifiedCodeString.append(arrOfCharacters[i])
                if i == 1 && i + 1 != arrOfCharacters.count {
                    modifiedCodeString.append("/")
                }
            }
        }
        return modifiedCodeString
    }
    
    private func isCardNumberValid (code: String) -> Bool {
        let codeRegex = "^\\d{4} - \\d{4} - \\d{4} - \\d{4}$"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codeTest.evaluate(with: code)
    }
    
    private func isDateValid (code: String) -> Bool {
        let codeRegex = "^\\d{2}/\\d{2}$"
        let codeTest = NSPredicate(format: "SELF MATCHES %@", codeRegex)
        return codeTest.evaluate(with: code)
    }
    
    private func checkValid () {
        guard
            let cardNumber = cardNumberTextField.text,
            let date = dateTextField.text,
            let cvv = cvvTextField.text
        else {
            setupAddButton(enabled: false)
            return
        }
        let isValid = isCardNumberValid(code: cardNumber) && isDateValid(code: date) && cvv.count == 3
        setupAddButton(enabled: isValid)
    }
}
