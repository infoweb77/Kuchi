import Foundation

struct FlashCard: Identifiable {
    var card: Challenge
    var isActive = true
    let id = UUID()
}

extension FlashCard: Equatable {
    static func == (lhs: FlashCard, rhs: FlashCard) -> Bool {
        return lhs.card.question == rhs.card.question
            && lhs.card.answer == rhs.card.answer
    }
}
