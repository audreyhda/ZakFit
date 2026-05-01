import Foundation

struct Bmr: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUser: UUID?
    var poids: Int?
    var taille: Int?
    var age: Int?
    var sexe: String?
}
