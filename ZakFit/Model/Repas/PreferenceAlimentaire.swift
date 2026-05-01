import Foundation

struct PreferenceAlimentaire: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUtilisateur: UUID?
    var nom: String?
}
