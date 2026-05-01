import Foundation

struct User: Codable, Identifiable, Hashable {
    var id: UUID?
    var nom: String
    var prenom: String
    var email: String
    var typeRegime: String?
}
