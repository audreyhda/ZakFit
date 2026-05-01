import SwiftUI

struct ObjectifView: View {
    @State private var showingCalorieSheet = false
    @State private var showingActiviteSheet = false

    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    Text("Mes objectifs")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    calorieSection
                    activiteSection
                }
                .padding(Spacing.l)
            }
        }
    }

    // MARK: - Calorie section

    private var calorieSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Calories")
                .font(.title2)
                .fontWeight(.semibold)

            if let objectif = contentViewModel.objectifsCalorie.first,
               let calorie = objectif.calorie {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("\(calorie) Kcal / jour")
                        .font(.title3)
                        .fontWeight(.semibold)
                    if let nom = objectif.nom, !nom.isEmpty {
                        Text("Source : \(nom)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Button("Modifier l'objectif") {
                    showingCalorieSheet = true
                }
                .buttonStyle(.secondary)
            } else {
                emptyState(
                    text: "Aucun objectif calorique défini",
                    cta: "Définir un objectif",
                    action: { showingCalorieSheet = true }
                )
            }
        }
        .card(tint: .green)
        .sheet(isPresented: $showingCalorieSheet) {
            ObjectifCalorieModalView()
                .environmentObject(contentViewModel)
        }
    }

    // MARK: - Activité section

    private var activiteSection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Activités")
                .font(.title2)
                .fontWeight(.semibold)

            if let objectif = contentViewModel.objectifsActivite.first {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    if let frequence = objectif.frequence {
                        Text("Fréquence : \(frequence) / semaine")
                            .font(.callout)
                    }
                    if let duree = objectif.duree {
                        Text("Durée : \(duree) min / séance")
                            .font(.callout)
                    }
                    if let calorie = objectif.calorie {
                        Text("Calories : \(calorie) Kcal")
                            .font(.callout)
                    }
                }
                Button("Modifier l'objectif") {
                    showingActiviteSheet = true
                }
                .buttonStyle(.secondary)
            } else {
                emptyState(
                    text: "Aucun objectif d'activité défini",
                    cta: "Définir un objectif",
                    action: { showingActiviteSheet = true }
                )
            }
        }
        .card(tint: .blue)
        .sheet(isPresented: $showingActiviteSheet) {
            ObjectifActviteModalView()
                .environmentObject(contentViewModel)
        }
    }

    // MARK: - Helpers

    private func emptyState(text: String, cta: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text(text)
                .font(.callout)
                .foregroundColor(.secondary)
            Button(action: action) {
                Label(cta, systemImage: "plus.circle.fill")
            }
            .buttonStyle(.primary)
        }
    }
}

#Preview {
    ObjectifView()
        .environmentObject(ContentViewModel())
}
