import SwiftUI

struct EditRepasView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    let repas: Repas
    let aliment: Aliment

    @State private var grams: Int
    @State private var isSaving: Bool = false
    @State private var isDeleting: Bool = false

    // Match the stored food name back to the local catalogue so we can
    // recalculate nutrition as the user changes the gram amount.
    private var foodItem: LocalFoodItem? {
        WholeFoodCatalogue.all.first { $0.nom == aliment.nom }
    }

    private var calories: Int {
        foodItem?.calories(forGrams: grams) ?? (aliment.calorie ?? 0)
    }
    private var proteines: Int {
        Int(foodItem?.proteine(forGrams: grams) ?? (aliment.proteine ?? 0))
    }
    private var glucides: Int {
        Int(foodItem?.glucide(forGrams: grams) ?? (aliment.glucide ?? 0))
    }
    private var lipides: Int {
        Int(foodItem?.lipide(forGrams: grams) ?? (aliment.lipide ?? 0))
    }

    init(repas: Repas, aliment: Aliment) {
        self.repas = repas
        self.aliment = aliment
        self._grams = State(initialValue: aliment.quantite ?? 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header ─────────────────────────────────────────────
            Text(aliment.nom ?? "Aliment")
                .font(.title2).fontWeight(.semibold)
            Text("Modifier la quantité ou supprimer")
                .font(.caption).foregroundColor(.secondary)
                .padding(.top, 2)
                .padding(.bottom, 16)

            Divider()

            // ── Gram picker (only when food is in catalogue) ───────
            if foodItem != nil {
                Text("Quantité en grammes")
                    .font(.callout).foregroundColor(.secondary)
                    .padding(.top, 16)

                Picker("Grammes", selection: $grams) {
                    ForEach(1...1000, id: \.self) { Text("\($0) g") }
                }
                .pickerStyle(.wheel)
                .frame(height: 150)

                // Live nutrition preview
                HStack(spacing: 8) {
                    nutritionCard(value: calories,  label: "Kcal")
                    nutritionCard(value: proteines, label: "Protéines")
                    nutritionCard(value: glucides,  label: "Glucides")
                    nutritionCard(value: lipides,   label: "Lipides")
                }
                .padding(.top, 8)
            } else {
                // Food not in local catalogue — show stored values read-only
                HStack(spacing: 8) {
                    nutritionCard(value: aliment.calorie ?? 0,           label: "Kcal")
                    nutritionCard(value: Int(aliment.proteine ?? 0),     label: "Protéines")
                    nutritionCard(value: Int(aliment.glucide ?? 0),      label: "Glucides")
                    nutritionCard(value: Int(aliment.lipide ?? 0),       label: "Lipides")
                }
                .padding(.top, 16)
                if let q = aliment.quantite {
                    Text("\(q) g")
                        .font(.caption).foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            }

            Spacer()

            // ── Actions ────────────────────────────────────────────
            VStack(spacing: 12) {
                if foodItem != nil {
                    Button {
                        guard !isSaving, let id = aliment.id, let food = foodItem else { return }
                        Task { @MainActor in
                            isSaving = true
                            await contentViewModel.updateAliment(id: id, food: food, grams: grams)
                            isSaving = false
                            dismiss()
                        }
                    } label: {
                        ButtonAddView(text: isSaving ? "Mise à jour…" : "Mettre à jour")
                    }
                    .disabled(isSaving || isDeleting)
                }

                Button {
                    guard !isDeleting, let id = repas.id else { return }
                    Task { @MainActor in
                        isDeleting = true
                        await contentViewModel.deleteRepas(id: id)
                        isDeleting = false
                        dismiss()
                    }
                } label: {
                    ButtonCancelView(text: isDeleting ? "Suppression…" : "Supprimer")
                }
                .disabled(isSaving || isDeleting)
            }
            .padding(.bottom, 8)
        }
        .padding(20)
    }

    private func nutritionCard(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2).fontWeight(.semibold)
            Text(label)
                .font(.caption).foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
