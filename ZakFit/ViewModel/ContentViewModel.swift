import Foundation
import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {
    // MARK: - Auth state
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    // MARK: - Reference data
    @Published var aliments: [Aliment] = []
    @Published var categoriesAliment: [CategorieAliment] = []
    @Published var categoriesRepas: [CategorieRepas] = []

    // MARK: - User data
    @Published var activites: [Activite] = []
    @Published var repas: [Repas] = []
    @Published var objectifsCalorie: [ObjectifCalorie] = []
    @Published var objectifsActivite: [ObjectifActivite] = []
    @Published var bmr: Bmr?

    @Published var errorMessage: ErrorMessage?

    /// Tracks the calendar day of the last successful data load.
    /// Used to detect midnight crossings and trigger an automatic reset.
    private var lastLoadDay: Date = .distantPast

    init() {
        if KeychainManager.getTokenFromKeychain() != nil {
            isAuthenticated = true
            Task { await loadAll() }
        }
        scheduleMidnightReset()
    }

    // MARK: - Auth

    func logout() {
        KeychainManager.deleteTokenFromKeychain()
        isAuthenticated = false
        currentUser = nil
        activites.removeAll()
        repas.removeAll()
        objectifsCalorie.removeAll()
        objectifsActivite.removeAll()
        bmr = nil
    }

    func fetchCurrentUser() async {
        do {
            let request = try APIClient.request("/utilisateur/me", authenticated: true)
            currentUser = try await APIClient.send(request, decode: User.self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            // silent: user stays cached
        }
    }

    // MARK: - Loading

    func loadAll() async {
        await fetchCurrentUser()
        await loadCatalogue()
        await loadUserData()
    }

    // MARK: - Midnight / day reset

    /// Called when the app returns to the foreground.
    /// Reloads user data if the calendar day has changed since the last load.
    func refreshIfNewDay() async {
        guard isAuthenticated else { return }
        guard !Calendar.current.isDate(lastLoadDay, inSameDayAs: Date()) else { return }
        lastLoadDay = Date()
        await loadUserData()
    }

    /// Schedules a Task that wakes at the next midnight and reloads user data.
    /// Re-schedules itself each time so it fires every night while the app is open.
    private func scheduleMidnightReset() {
        let calendar = Calendar.current
        guard let midnight = calendar.nextDate(
            after: Date(),
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else { return }

        let delay = midnight.timeIntervalSinceNow
        Task { @MainActor [weak self] in
            guard let self else { return }
            try? await Task.sleep(for: .seconds(delay))
            guard self.isAuthenticated else {
                self.scheduleMidnightReset()
                return
            }
            self.lastLoadDay = Date()
            await self.loadUserData()
            self.scheduleMidnightReset()   // reschedule for the next midnight
        }
    }

    func loadCatalogue() async {
        if let request = try? APIClient.request("/aliment"),
           let result = try? await APIClient.send(request, decode: [Aliment].self) {
            aliments = result
        }
        if let request = try? APIClient.request("/categorie_aliment"),
           let result = try? await APIClient.send(request, decode: [CategorieAliment].self) {
            categoriesAliment = result
        }
        if let request = try? APIClient.request("/categorie_repas"),
           let result = try? await APIClient.send(request, decode: [CategorieRepas].self) {
            categoriesRepas = result
        }
    }

    func loadUserData() async {
        await loadActivites()
        await loadRepas()
        await loadObjectifsCalorie()
        await loadObjectifsActivite()
        await loadBmr()
        lastLoadDay = Date()
    }

    func loadActivites() async {
        do {
            let request = try APIClient.request("/activite", authenticated: true)
            activites = try await APIClient.send(request, decode: [Activite].self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            // silent
        }
    }

    func loadRepas() async {
        do {
            let request = try APIClient.request("/repas", authenticated: true)
            repas = try await APIClient.send(request, decode: [Repas].self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            // silent
        }
    }

    func loadObjectifsCalorie() async {
        do {
            let request = try APIClient.request("/objectif_calorique", authenticated: true)
            objectifsCalorie = try await APIClient.send(request, decode: [ObjectifCalorie].self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            // silent
        }
    }

    func loadObjectifsActivite() async {
        do {
            let request = try APIClient.request("/objectif_activite", authenticated: true)
            objectifsActivite = try await APIClient.send(request, decode: [ObjectifActivite].self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            // silent
        }
    }

    func loadBmr() async {
        do {
            let request = try APIClient.request("/bmr", authenticated: true)
            bmr = try await APIClient.send(request, decode: Bmr.self)
        } catch {
            bmr = nil
        }
    }

    // MARK: - Data mutations

    func addRepas(idAliment: UUID, idCategorieRepas: UUID, date: Date = Date()) async {
        let payload = Repas(
            id: UUID(),
            idUtilisateur: nil,
            idAliment: idAliment,
            dateRepas: date,
            idCategorieRepas: idCategorieRepas
        )
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/repas", method: "POST", body: body, authenticated: true)
            let created = try await APIClient.send(request, decode: Repas.self)
            repas.insert(created, at: 0)
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func updateAliment(id: UUID, food: LocalFoodItem, grams: Int) async {
        let payload = Aliment(
            id: id,
            idCategorieAliment: nil,
            nom: food.nom,
            quantite: grams,
            calorie: food.calories(forGrams: grams),
            proteine: food.proteine(forGrams: grams),
            glucide: food.glucide(forGrams: grams),
            lipide: food.lipide(forGrams: grams)
        )
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/aliment/\(id)", method: "PUT", body: body, authenticated: true)
            let updated = try await APIClient.send(request, decode: Aliment.self)
            if let index = aliments.firstIndex(where: { $0.id == id }) {
                aliments[index] = updated
            }
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func deleteRepas(id: UUID) async {
        do {
            let request = try APIClient.request("/repas/\(id)", method: "DELETE", authenticated: true)
            try await APIClient.sendVoid(request)
            repas.removeAll { $0.id == id }
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func addActivite(nom: String, duree: Double, calorieBrulee: Double, date: Date = Date()) async {
        let payload = Activite(
            id: UUID(),
            idUtilisateur: nil,
            nom: nom,
            dateActivite: date,
            calorieBrulee: calorieBrulee,
            duree: duree
        )
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/activite", method: "POST", body: body, authenticated: true)
            let created = try await APIClient.send(request, decode: Activite.self)
            activites.insert(created, at: 0)
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func updateActivite(id: UUID, nom: String, duree: Double, calorieBrulee: Double) async {
        let payload = Activite(
            id: id,
            idUtilisateur: nil,
            nom: nom,
            dateActivite: nil,
            calorieBrulee: calorieBrulee,
            duree: duree
        )
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/activite/\(id)", method: "PUT", body: body, authenticated: true)
            let updated = try await APIClient.send(request, decode: Activite.self)
            if let index = activites.firstIndex(where: { $0.id == id }) {
                activites[index] = updated
            }
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func deleteActivite(id: UUID) async {
        do {
            let request = try APIClient.request("/activite/\(id)", method: "DELETE", authenticated: true)
            try await APIClient.sendVoid(request)
            activites.removeAll { $0.id == id }
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func setObjectifCalorie(calorie: Int, nom: String = "Objectif quotidien") async {
        let payload = ObjectifCalorie(
            id: UUID(),
            idUser: currentUser?.id,
            nom: nom,
            calorie: calorie,
            etat: "actif"
        )
        // Optimistic local update so the view reflects the user's choice immediately.
        objectifsCalorie = [payload]
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/objectif_calorique", method: "POST", body: body, authenticated: true)
            let created = try await APIClient.send(request, decode: ObjectifCalorie.self)
            objectifsCalorie = [created]
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func addObjectifActivite(_ objectif: ObjectifActivite) async {
        var local = objectif
        if local.id == nil { local.id = UUID() }
        if local.idUser == nil { local.idUser = currentUser?.id }
        // Optimistic local update — only one active objectif activité at a time.
        objectifsActivite = [local]
        do {
            let body = try APIClient.jsonEncoder.encode(local)
            let request = try APIClient.request("/objectif_activite", method: "POST", body: body, authenticated: true)
            let created = try await APIClient.send(request, decode: ObjectifActivite.self)
            objectifsActivite = [created]
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    func saveBmr(poids: Int, taille: Int, age: Int, sexe: String? = nil) async {
        let payload = Bmr(
            id: bmr?.id ?? UUID(),
            idUser: currentUser?.id,
            poids: poids,
            taille: taille,
            age: age,
            sexe: sexe ?? bmr?.sexe
        )
        // Optimistic local update so profile + objectif views see the new values immediately.
        bmr = payload
        do {
            let body = try APIClient.jsonEncoder.encode(payload)
            let request = try APIClient.request("/bmr", method: "POST", body: body, authenticated: true)
            bmr = try await APIClient.send(request, decode: Bmr.self)
        } catch APIError.unauthorized {
            logout()
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
        }
    }

    // MARK: - Dashboard helpers

    private func aliment(for id: UUID?) -> Aliment? {
        guard let id else { return nil }
        return aliments.first { $0.id == id }
    }

    private func nutrition(for repas: Repas) -> (cal: Int, prot: Double, lip: Double, glu: Double) {
        guard let aliment = aliment(for: repas.idAliment) else { return (0, 0, 0, 0) }
        return (aliment.calorie ?? 0, aliment.proteine ?? 0, aliment.lipide ?? 0, aliment.glucide ?? 0)
    }

    var todayRepas: [Repas] {
        let calendar = Calendar.current
        return repas.filter { item in
            guard let date = item.dateRepas else { return false }
            return calendar.isDateInToday(date)
        }
    }

    var todayActivites: [Activite] {
        let calendar = Calendar.current
        return activites.filter { item in
            guard let date = item.dateActivite else { return false }
            return calendar.isDateInToday(date)
        }
    }

    var caloriesEaten: Int {
        todayRepas.reduce(0) { $0 + nutrition(for: $1).cal }
    }

    var caloriesBurned: Int {
        Int(todayActivites.reduce(0.0) { $0 + ($1.calorieBrulee ?? 0) })
    }

    var calorieGoal: Int {
        objectifsCalorie.first?.calorie ?? 2000
    }

    var caloriesRemaining: Int {
        max(0, calorieGoal - caloriesEaten + caloriesBurned)
    }

    /// 0 → no calories eaten, 1 → goal reached.
    var caloriesProgress: CGFloat {
        let goal = max(1, calorieGoal)
        return CGFloat(caloriesEaten) / CGFloat(goal)
    }

    var totalProteine: Double { todayRepas.reduce(0) { $0 + nutrition(for: $1).prot } }
    var totalLipide: Double { todayRepas.reduce(0) { $0 + nutrition(for: $1).lip } }
    var totalGlucide: Double { todayRepas.reduce(0) { $0 + nutrition(for: $1).glu } }

    /// Macro targets derived from the daily calorie goal (30% protein / 30% fat / 40% carbs).
    var targetProteine: Double { Double(calorieGoal) * 0.30 / 4.0 }
    var targetLipide: Double { Double(calorieGoal) * 0.30 / 9.0 }
    var targetGlucide: Double { Double(calorieGoal) * 0.40 / 4.0 }

    var proteineProgress: CGFloat { CGFloat(totalProteine / max(1, targetProteine)) }
    var lipideProgress: CGFloat { CGFloat(totalLipide / max(1, targetLipide)) }
    var glucideProgress: CGFloat { CGFloat(totalGlucide / max(1, targetGlucide)) }

    func caloriesEaten(in categorieID: UUID) -> Int {
        todayRepas
            .filter { $0.idCategorieRepas == categorieID }
            .reduce(0) { $0 + nutrition(for: $1).cal }
    }

    // MARK: - Local food catalogue

    /// Creates a gram-scaled aliment entry in the DB, then saves the repas.
    /// Each call creates its own aliment record so the stored calorie value
    /// reflects the exact portion size the user chose (e.g. 250 g avocado = 400 kcal).
    func addRepasFromLocal(food: LocalFoodItem, grams: Int, categorieRepasID: UUID) async {
        guard let alimentID = await createScaledAliment(from: food, grams: grams) else { return }
        await addRepas(idAliment: alimentID, idCategorieRepas: categorieRepasID)
    }

    @discardableResult
    private func createScaledAliment(from food: LocalFoodItem, grams: Int) async -> UUID? {
        let newAliment = Aliment(
            id: UUID(),
            idCategorieAliment: nil,
            nom: food.nom,
            quantite: grams,
            calorie: food.calories(forGrams: grams),
            proteine: food.proteine(forGrams: grams),
            glucide: food.glucide(forGrams: grams),
            lipide: food.lipide(forGrams: grams)
        )
        do {
            let body = try APIClient.jsonEncoder.encode(newAliment)
            let request = try APIClient.request("/aliment", method: "POST", body: body, authenticated: true)
            let created = try await APIClient.send(request, decode: Aliment.self)
            aliments.append(created)
            return created.id
        } catch APIError.unauthorized {
            logout()
            return nil
        } catch {
            errorMessage = ErrorMessage(message: error.localizedDescription)
            return nil
        }
    }
}
