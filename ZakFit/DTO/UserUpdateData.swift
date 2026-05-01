import Foundation

struct UserUpdateData: Codable {
    var nom: String?
    var prenom: String?
    var email: String?
    var mdp: String?
    var typeRegime: String?
}
