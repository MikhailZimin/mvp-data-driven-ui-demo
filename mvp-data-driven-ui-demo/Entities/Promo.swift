import Foundation

struct Promo {
    let id: String
    let imageURL: URL
    let title: String
    let issueDate: String
    let promoDescription: String

    enum State {
        case pending
        case active
    }
}
