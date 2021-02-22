
import UIKit

class ProfileViewController: BaseViewController {
    
    override class var storyboard: Storyboard {
        return .profile
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePhoto: UIImageView!
    
    let dataSource = TableViewSections.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationController?.isNavigationBarHidden = true
        profilePhoto.layer.cornerRadius = profilePhoto.bounds.height / 2
    }
    
    private func configureTableView() {
        tableView.register(cellType: DefaultCell.self)
        tableView.register(cellType: SwitchCell.self)
        tableView.register(cellType: ButtonCell.self)
        tableView.register(cellType: CardListCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func addPhotoButtonPressed() {
        let vc = PhotoGuideViewController.instantiate()
        vc.isFromRegistration = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = dataSource[indexPath.section].rows[indexPath.row]
        let cell: UITableViewCell
        switch rowModel.cellType {
        case is ButtonCell.Type:
            let buttonCell = tableView.cell(cellType: ButtonCell.self)
            buttonCell.configure(rowModel: rowModel)
            cell = buttonCell
        case is SwitchCell.Type:
            let switchCell = tableView.cell(cellType: SwitchCell.self)
            switchCell.configure(rowModel: rowModel, isOn: true)
            switchCell.cellDelegate = self
            cell = switchCell
        case is CardListCell.Type:
            let cardListCell = tableView.cell(cellType: CardListCell.self)
            cardListCell.configure(title: rowModel.cellTitle, cardNumber: "5444444444444444")
            cell = cardListCell
        case is DefaultCell.Type:
            let defaultCell = tableView.cell(cellType: DefaultCell.self)
            defaultCell.configure(rowModel: rowModel)
            cell = defaultCell
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let text = dataSource[section].title else {
            return nil
        }
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.frame.size.width - 32, height: 46))
        label.font = Theme.Fonts.themeFont()
        label.textColor = Theme.Colors.themeDarkGray
        label.text = text
        
        containerView.addSubview(label)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = Theme.Colors.themeMidGray
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = dataSource[section]
        if section.title != nil {
            return section.headerHeight
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowModel = dataSource[indexPath.section].rows[indexPath.row]
        return rowModel.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowModel = dataSource[indexPath.section].rows[indexPath.row]
        switch rowModel {
        case .metroScheme:
            let vc = MetroMapSchemeViewController.instantiate()
            navigationController?.pushViewController(vc, animated: true)
        case .cards:
            let vc = CardsViewController.instantiate()
            navigationController?.pushViewController(vc, animated: false)
        case .changePinCode:
            let alertVC = PinCodeConfirmAlertViewController.instantiate(pinCode: "1111")
            alertVC.cancelAction = {
                
            }
            alertVC.confirmAction = { success in
                let vc = PinCodeViewController.instantiate()
                vc.isFromRegistration = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
            present(alertVC, animated: false)
        case .help:
            break
        case .developers:
            break
        case .logOut:
            break
        case .deleteProfile:
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - SwitchCellDelegate
extension ProfileViewController: SwitchCellDelegate {
    func stateChanged(isOn: Bool) {
        
    }
}

// MARK: - Table model
extension ProfileViewController {
    enum TableViewSections: CaseIterable {
        case faceId
        case metro
        case cards
        case security
        case info
        case logOutAction
        case deleteAction
    
        enum TableViewRow {
            case faceIdPayment
            case metroScheme
            case cards
            case bioAuth
            case changePinCode
            case help
            case developers
            case logOut
            case deleteProfile
            
            var cellType: UITableViewCell.Type {
                switch self {
                case .faceIdPayment, .bioAuth:
                    return SwitchCell.self
                case .metroScheme, .changePinCode, .logOut, .deleteProfile:
                    return ButtonCell.self
                case .cards:
                    return CardListCell.self
                case .help, .developers:
                    return DefaultCell.self
                }
            }
                        
            var cellTextColor: UIColor {
                switch self {
                case .faceIdPayment:
                    return Theme.Colors.themeBlack
                case .metroScheme:
                    return Theme.Colors.themeBlack
                case .logOut:
                    return Theme.Colors.themeGreen
                case .deleteProfile:
                    return Theme.Colors.themeRed
                default:
                    return Theme.Colors.themeDarkGray
                }
            }
            
            var cellImage: UIImage? {
                switch self {
                case .metroScheme:
                    return UIImage(named: "logo-green")
                case .changePinCode:
                    return UIImage(named: "lock-icon")
                case .logOut:
                    return UIImage(named: "logout-icon")
                default:
                    return nil
                }
            }
            
            var cellTitle: String {
                switch self {
                case .faceIdPayment:
                    return "Платежі за допомогою лиця"
                case .metroScheme:
                    return "Схема метро"
                case .cards:
                    return "Платіжні карти"
                case .bioAuth:
                    return "Touch/Face ID для входу"
                case .changePinCode:
                    return "Змінити пін-код"
                case .help:
                    return "Допомога"
                case .developers:
                    return "Розробники"
                case .logOut:
                    return "Вийти з профілю"
                case .deleteProfile:
                    return "Видалити профіль"
                }
            }
            
            var cellHeight: CGFloat {
                switch self {
                case .cards:
                    return 109
                case .logOut, .deleteProfile:
                    return 48
                default:
                    return 55
                }
            }
        }
        
        var title: String? {
            switch self {
            case .security:
                return "Безпека"
            case .info:
                return "Про додаток"
            case .logOutAction:
                return ""
            default:
                return nil
            }
        }
        
        var rows: [TableViewRow] {
            switch self {
            case .faceId:
                return [.faceIdPayment]
            case .metro:
                return [.metroScheme]
            case .cards:
                return [.cards]
            case .security:
                return [.bioAuth, .changePinCode]
            case .info:
                return [.help, .developers]
            case .logOutAction:
                return [.logOut]
            case .deleteAction:
                return [.deleteProfile]
            }
        }
        
        var headerHeight: CGFloat {
            switch self {
            case .security, .info:
                return 46
            case .logOutAction:
                return 25
            default:
                return 0
            }
        }
    }
    
}

