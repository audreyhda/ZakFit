import Foundation

@MainActor
final class UserLoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var mdp = ""
    @Published var errorMessage: ErrorMessage?

    func login(contentViewModel: ContentViewModel) async {
        var errors: [String] = []
        if email.isEmpty {
            errors.append("L'adresse email est obligatoire.")
        } else if !isValidEmail(email) {
            errors.append("L'adresse email n'est pas valide.")
        }
        if mdp.isEmpty {
            errors.append("Le mot de passe est obligatoire.")
        }

        if !errors.isEmpty {
            errorMessage = ErrorMessage(message: errors.joined(separator: "\n"))
            return
        }

        do {
            let body = try APIClient.jsonEncoder.encode(UserLoginData(email: email, mdp: mdp))
            let request = try APIClient.request("/utilisateur/login", method: "POST", body: body)
            let response = try await APIClient.send(request, decode: AuthResponse.self)
            KeychainManager.saveTokenToKeychain(token: response.token)
            contentViewModel.isAuthenticated = true
            contentViewModel.currentUser = response.user
            await contentViewModel.loadAll()
        } catch let APIError.server(reason, _) {
            errorMessage = ErrorMessage(message: reason)
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
