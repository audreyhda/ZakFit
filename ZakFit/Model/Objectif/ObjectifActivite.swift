import Foundation

struct ObjectifActivite: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUser: UUID?
    var nom: String?
    var calorie: Int?
    var frequence: Int?
    var duree: Int?
    var dateLimite: Date?
    var etat: String?
}
