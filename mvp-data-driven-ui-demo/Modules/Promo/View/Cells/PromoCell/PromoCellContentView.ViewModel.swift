import UIKit

extension PromoCellContentView {
    struct ViewModel: DataDrivenModel, UIContentConfiguration, Hashable {
        let imageURL: URL?
        let title: String
        let action: Command?

        // MARK: - Conforming of the Hashable

        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            lhs.imageURL == rhs.imageURL && lhs.title == rhs.title
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(imageURL)
            hasher.combine(title)
        }

        // MARK: - Conforming of the UIContentConfiguration

        func makeContentView() -> UIView & UIContentView {
            let contentView = PromoCellContentView()
            contentView.render(model: self)

            return contentView
        }

        func updated(for state: UIConfigurationState) -> ViewModel {
            self
        }
    }
}
