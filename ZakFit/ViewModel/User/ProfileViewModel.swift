import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var nom = ""
    @Published var prenom = ""
    @Published var email = ""
    @Published var mdp = ""
    @Published var typeRegime = ""
    @Published var taille: Double = 170
    @Published var poids: Double = 65
    @Published var age: Int = 25
    @Published var errorMessage: ErrorMessage?
    @Published var isLoading = false

    func load(from contentViewModel: ContentViewModel) {
        if let user = contentViewModel.currentUser {
            nom = user.nom
            prenom = user.prenom
            email = user.email
            typeRegime = user.typeRegime ?? ""
        }
        if let bmr = contentViewModel.bmr {
            if let p = bmr.poids { poids = Double(p) }
            if let t = bmr.taille { taille = Double(t) }
            if let a = bmr.age { age = a }
        }
    }

    func update(contentViewModel: ContentViewModel) async {
        isLoading = true
        defer { isLoading = false }
        do {
            var update = UserUpdateData()
            update.nom = nom.isEmpty ? nil : nom
            update.prenom = prenom.isEmpty ? nil : prenom
            update.email = email.isEmpty ? nil : email
            update.mdp = mdp.isEmpty ? nil : mdp
            update.typeRegime = typeRegime.isEmpty ? nil : typeRegime

            let body = try APIClient.jsonEncoder.encode(update)
            let request = try APIClient.request("/utilisateur/me", method: "PUT", body: body, authenticated: true)
            let user = try await APIClient.send(request, decode: User.self)
            contentViewModel.currentUser = user

            await contentViewModel.saveBmr(poids: Int(poids), taille: Int(taille), age: age)
        } catch APIError.unauthorized {
            contentViewModel.logout()
        } catch let APIError.server(reason, _) {
            errorMessage = ErrorMessage(message: reason)
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }
}
