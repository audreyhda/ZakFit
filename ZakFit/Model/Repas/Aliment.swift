import Foundation

struct Aliment: Codable, Identifiable, Hashable {
    var id: UUID?
    var idCategorieAliment: UUID?
    var nom: String?
    var quantite: Int?
    var calorie: Int?
    var proteine: Double?
    var glucide: Double?
    var lipide: Double?

    init(id: UUID? = nil, idCategorieAliment: UUID? = nil, nom: String? = nil, quantite: Int? = nil, calorie: Int? = nil, proteine: Double? = nil, glucide: Double? = nil, lipide: Double? = nil) {
        self.id = id
        self.idCategorieAliment = idCategorieAliment
        self.nom = nom
        self.quantite = quantite
        self.calorie = calorie
        self.proteine = proteine
        self.glucide = glucide
        self.lipide = lipide
    }
}
