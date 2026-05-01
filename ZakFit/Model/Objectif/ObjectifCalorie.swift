import Foundation

struct ObjectifCalorie: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUser: UUID?
    var nom: String?
    var calorie: Int?
    var etat: String?
}
