

import UIKit

class PhotoGuideViewController: BaseViewController {
        
    override class var storyboard: Storyboard {
        return .photo
    }
    
    var photoPickerVC: KMPhotoPickerController!
    
    var isFromRegistration: Bool = false
    
    @IBOutlet weak var companyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        if isFromRegistration {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
            navigationController?.navigationBar.backItem?.title = "Профіль"
        }
    }
    
    private func configureView() {
        let attributedText = NSMutableAttributedString(string: "Система розпізнавання розроблена ", attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont(size: 11)
        ])
        
        attributedText.append(NSAttributedString(string: "Riddletag", attributes: [
            .foregroundColor: Theme.Colors.themeDarkGray,
            .font: Theme.Fonts.themeFont(size: 11),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]))
        
        companyLabel.attributedText = attributedText
    }
    
    // MARK: - Actions
    @IBAction func takePhotoPressed() {
        if photoPickerVC == nil {
            photoPickerVC = KMPhotoPickerController()
            photoPickerVC.configure()
            photoPickerVC.delegate = self
        }
        present(photoPickerVC, animated: true)
    }
}

extension PhotoGuideViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        photoPickerVC.showHUD()
        // TODO: - Add Network integration
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.photoPickerVC.hideHUD()
            picker.dismiss(animated: true) {
                let vc = RegisterSuccessViewControler.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
