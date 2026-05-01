import Foundation

struct Activite: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUtilisateur: UUID?
    var nom: String
    var dateActivite: Date?
    var calorieBrulee: Double?
    var duree: Double?

    var emoji: String {
        Self.emojiFor(nom: nom)
    }

    static func emojiFor(nom: String) -> String {
        switch nom.lowercased() {
        case "force": return "💪"
        case "yoga": return "🧘"
        case "vélo", "velo": return "🚴"
        case "natation": return "🏊"
        case "hiit": return "🥵"
        case "marche": return "🚶"
        default: return "❓"
        }
    }
}
