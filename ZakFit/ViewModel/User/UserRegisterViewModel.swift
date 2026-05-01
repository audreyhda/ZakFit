import Foundation

@MainActor
final class UserRegisterViewModel: ObservableObject {
    @Published var nom = ""
    @Published var prenom = ""
    @Published var email = ""
    @Published var mdp = ""
    @Published var errorMessage: ErrorMessage?

    func registration(contentViewModel: ContentViewModel) async {
        var errors: [String] = []
        if nom.isEmpty { errors.append("Le nom est obligatoire.") }
        if prenom.isEmpty { errors.append("Le prénom est obligatoire.") }
        if email.isEmpty {
            errors.append("L'adresse email est obligatoire.")
        } else if !isValidEmail(email) {
            errors.append("L'adresse email n'est pas valide.")
        }
        if mdp.count < 8 {
            errors.append("Le mot de passe doit contenir au moins 8 caractères.")
        }

        if !errors.isEmpty {
            errorMessage = ErrorMessage(message: errors.joined(separator: "\n"))
            return
        }

        do {
            let payload = UserRegistrationData(nom: nom, prenom: prenom, email: email, mdp: mdp, typeRegime: nil)
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/utilisateur/create", method: "POST", body: body)
            let response = try await APIClient.send(request, decode: AuthResponse.self)
            KeychainManager.saveTokenToKeychain(token: response.token)
            contentViewModel.isAuthenticated = true
            contentViewModel.currentUser = response.user
            await contentViewModel.loadAll()
        } catch let APIError.server(reason, _) {
            if reason.contains("already exists") {
                errorMessage = ErrorMessage(message: "Cette adresse e-mail est déjà associée à un compte.")
            } else {
                errorMessage = ErrorMessage(message: reason)
            }
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
