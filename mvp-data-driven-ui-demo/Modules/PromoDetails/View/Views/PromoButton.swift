import UIKit

final class PromoButton: UIButton {
    private var command: Command?

    // MARK: - Managing the Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
    }

    // MARK: - Conforming of the PromoDetailsViewInput

    func render(model: ViewModel) {
        // пример применения анимации
        addAnimation(keyPath: #keyPath(UIButton.backgroundColor))
        backgroundColor = model.backgroundColor

        isEnabled = model.isEnabled
        setTitle(model.title, for: .normal)
        command = model.action
    }

    @objc
    private func handleTouchUpInside() {
        command?.execute()
    }

    // MARK: - Managing the ViewModel

    enum ViewModel {
        case loading
        case pending(Command)
        case active
        case failed(Command)

        var backgroundColor: UIColor {
            switch self {
            case .loading:
                return .lightGray
            case .pending:
                return .systemBlue.withAlphaComponent(0.7)
            case .active:
                return .systemGreen.withAlphaComponent(0.7)
            case .failed:
                return .systemRed.withAlphaComponent(0.7)
            }
        }

        var title: String {
            switch self {
            case .loading:
                return "Информация загружается"
            case .pending:
                return "Принять участие"
            case .active:
                return "Активировано"
            case .failed:
                return "Запросить статус"
            }
        }

        var action: Command? {
            switch self {
            case let .failed(action):
                return action
            case let .pending(action):
                return action
            case .active, .loading:
                return nil
            }
        }

        var isEnabled: Bool {
            action != nil
        }
    }
}
