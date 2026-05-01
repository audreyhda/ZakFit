import SwiftUI

struct TableauBordView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel

    @State private var showRepasModal: Bool = false
    @State private var showActiviteModal: Bool = false

    // Edit sheets
    @State private var selectedActivite: Activite? = nil
    @State private var selectedRepasSelection: RepasSelection? = nil

    private struct RepasSelection: Identifiable {
        let id: UUID
        let repas: Repas
        let aliment: Aliment
        init(repas: Repas, aliment: Aliment) {
            self.id = repas.id ?? UUID()
            self.repas = repas
            self.aliment = aliment
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    Text("Aujourd'hui")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    calorieSummarySection
                    addRepasCard
                    addActiviteCard
                    todaysSummaryCard
                }
                .padding(Spacing.l)
            }
            .refreshable {
                await contentViewModel.loadUserData()
            }
        }
        .sheet(item: $selectedActivite) { activite in
            EditActiviteView(activite: activite)
                .environmentObject(contentViewModel)
        }
        .sheet(item: $selectedRepasSelection) { sel in
            EditRepasView(repas: sel.repas, aliment: sel.aliment)
                .environmentObject(contentViewModel)
        }
        .task {
            if contentViewModel.objectifsCalorie.isEmpty {
                await contentViewModel.loadUserData()
            }
        }
    }

    // MARK: - Calorie summary card

    private var calorieSummarySection: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Text("Calories de la journée")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(spacing: Spacing.m) {
                HStack {
                    calorieStat(label: "\(contentViewModel.caloriesEaten)", subtitle: "Mangées")
                    progressStat(
                        progress: contentViewModel.caloriesProgress,
                        color: .green,
                        label: "\(contentViewModel.caloriesRemaining)",
                        subtitle: "Reste"
                    )
                    calorieStat(label: "\(contentViewModel.caloriesBurned)", subtitle: "Brûlées")
                }

                HStack {
                    nutrientProgress(
                        label: "\(Int(contentViewModel.totalProteine))",
                        progress: contentViewModel.proteineProgress,
                        color: .red,
                        text: "protéines"
                    )
                    nutrientProgress(
                        label: "\(Int(contentViewModel.totalLipide))",
                        progress: contentViewModel.lipideProgress,
                        color: .yellow,
                        text: "lipides"
                    )
                    nutrientProgress(
                        label: "\(Int(contentViewModel.totalGlucide))",
                        progress: contentViewModel.glucideProgress,
                        color: .blue,
                        text: "glucides"
                    )
                }
            }
            .card(tint: .green)
        }
    }

    // MARK: - Add repas card

    private var addRepasCard: some View {
        Button {
            showRepasModal = true
        } label: {
            VStack(alignment: .leading, spacing: Spacing.m) {
                HStack {
                    Text("Ajouter un repas")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }

                HStack(spacing: 0) {
                    ForEach(MealCatalogue.categories) { cat in
                        let kcal = contentViewModel.caloriesEaten(in: cat.id)
                        VStack(spacing: Spacing.xs) {
                            Text(cat.emoji).font(.title2)
                            Text("\(kcal)")
                                .font(.caption)
                                .fontWeight(.semibold)
                            Text("kcal")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .card(tint: .orange)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Ajouter un repas")
        .sheet(isPresented: $showRepasModal) {
            AjouterRepasModalView(isPresented: $showRepasModal)
                .environmentObject(contentViewModel)
        }
    }

    // MARK: - Add activite card

    private var addActiviteCard: some View {
        Button {
            showActiviteModal = true
        } label: {
            VStack(alignment: .leading, spacing: Spacing.m) {
                HStack {
                    Text("Ajouter une activité")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                }

                HStack(spacing: 0) {
                    ForEach(["💪", "🧘", "🚴", "🏊", "🥵", "🚶"], id: \.self) { emoji in
                        Text(emoji).font(.title2).frame(maxWidth: .infinity)
                    }
                }
            }
            .card(tint: .blue)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Ajouter une activité")
        .sheet(isPresented: $showActiviteModal) {
            AjouterActiviteModalView(isPresented: $showActiviteModal)
                .environmentObject(contentViewModel)
        }
    }

    // MARK: - Today's summary card

    private var todaysSummaryCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {

            // ── Meals ────────────────────────────────────────────────
            Text("Mes repas")
                .font(.title2)
                .fontWeight(.semibold)

            if contentViewModel.todayRepas.isEmpty {
                Text("Aucun repas enregistré aujourd'hui.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: Spacing.s) {
                    ForEach(MealCatalogue.categories) { cat in
                        let mealsInCat = contentViewModel.todayRepas.filter {
                            $0.idCategorieRepas == cat.id
                        }
                        if !mealsInCat.isEmpty {
                            mealCategorySection(cat: cat, meals: mealsInCat)
                        }
                    }
                }
            }

            Divider()

            // ── Activities ──────────────────────────────────────────
            Text("Mes activités")
                .font(.title2)
                .fontWeight(.semibold)

            if contentViewModel.todayActivites.isEmpty {
                Text("Aucune activité enregistrée aujourd'hui.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Spacing.s) {
                        ForEach(contentViewModel.todayActivites) { activite in
                            activiteChip(activite)
                        }
                    }
                }
            }
        }
        .card()
    }

    private func mealCategorySection(cat: LocalCategorieRepas, meals: [Repas]) -> some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            HStack {
                Text(cat.emoji)
                Text(cat.nom)
                    .font(.subheadline).fontWeight(.semibold)
                Spacer()
                Text("\(contentViewModel.caloriesEaten(in: cat.id)) kcal")
                    .font(.caption).foregroundColor(.secondary)
            }

            ForEach(meals) { repas in
                if let aliment = contentViewModel.aliments.first(where: { $0.id == repas.idAliment }) {
                    Button {
                        selectedRepasSelection = RepasSelection(repas: repas, aliment: aliment)
                    } label: {
                        HStack {
                            Text(aliment.nom ?? "")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            if let q = aliment.quantite {
                                Text("(\(q) g)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("\(aliment.calorie ?? 0) kcal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, Spacing.s)
                        .padding(.horizontal, Spacing.m)
                        .frame(minHeight: 44)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(Spacing.s)
        .background(
            RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
                .fill(Color.yellow.opacity(0.18))
        )
    }

    private func activiteChip(_ activite: Activite) -> some View {
        Button {
            selectedActivite = activite
        } label: {
            VStack(spacing: Spacing.xs) {
                Text(activite.emoji).font(.title2)
                Text(activite.nom)
                    .font(.caption).fontWeight(.medium)
                    .foregroundColor(.primary)
                Text("\(Int(activite.duree ?? 0)) min")
                    .font(.caption2).foregroundColor(.secondary)
                Text("\(Int(activite.calorieBrulee ?? 0)) kcal")
                    .font(.caption2).foregroundColor(.secondary)
            }
            .padding(Spacing.m)
            .frame(minWidth: 80, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
                    .fill(Color.yellow.opacity(0.18))
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Modifier l'activité \(activite.nom)")
    }

    // MARK: - Reusable cells

    private func calorieStat(label: String, subtitle: String) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(label)
                .font(.title2).fontWeight(.bold)
            Text(subtitle).font(.subheadline).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func progressStat(progress: CGFloat, color: Color, label: String, subtitle: String) -> some View {
        ZStack {
            CircularProgressView(progress: progress, color: color, text: "")
                .frame(width: 120, height: 120)
            VStack(spacing: Spacing.xs) {
                Text(label)
                    .font(.title2).fontWeight(.bold)
                Text(subtitle).font(.subheadline).foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func nutrientProgress(label: String, progress: CGFloat, color: Color, text: String) -> some View {
        ZStack {
            CircularProgressView(progress: progress, color: color, text: text)
                .frame(width: 80, height: 80)
            Text(label)
                .font(.headline).fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TableauBordView()
        .environmentObject(ContentViewModel())
}
