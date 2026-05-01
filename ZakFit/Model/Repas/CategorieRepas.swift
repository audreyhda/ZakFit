import Foundation

struct CategorieRepas: Codable, Identifiable, Hashable {
    var id: UUID?
    var nom: String

    var emoji: String {
        Self.emojiFor(nom: nom)
    }

    static func emojiFor(nom: String) -> String {
        switch nom.lowercased() {
        case "petit déjeuner", "petit-déjeuner": return "🥐"
        case "déjeuner": return "🥘"
        case "dîner": return "🥗"
        case "snack", "collation": return "🍎"
        default: return "🍽️"
        }
    }
}
