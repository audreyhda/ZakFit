import Foundation

struct Repas: Codable, Identifiable, Hashable {
    var id: UUID?
    var idUtilisateur: UUID?
    var idAliment: UUID?
    var dateRepas: Date?
    var idCategorieRepas: UUID
}
