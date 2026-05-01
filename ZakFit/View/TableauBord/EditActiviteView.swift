import SwiftUI

struct EditActiviteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    let activite: Activite

    @State private var duree: Int
    @State private var isSaving: Bool = false
    @State private var isDeleting: Bool = false

    // Calorie rate (kcal / min) inferred from the original entry
    private let ratePerMinute: Double

    private var caloriesBurned: Double {
        ratePerMinute * Double(duree)
    }

    init(activite: Activite) {
        self.activite = activite
        let d = max(1, Int(activite.duree ?? 20))
        self._duree = State(initialValue: d)
        let cals = activite.calorieBrulee ?? 0
        let mins = activite.duree ?? 1
        self.ratePerMinute = mins > 0 ? cals / mins : 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Header ─────────────────────────────────────────────
            HStack(spacing: 12) {
                Text(activite.emoji).font(.largeTitle)
                VStack(alignment: .leading, spacing: 2) {
                    Text(activite.nom)
                        .font(.title2).fontWeight(.semibold)
                    Text("Modifier ou supprimer")
                        .font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 20)

            Divider()

            // ── Duration picker ────────────────────────────────────
            Text("Durée en minutes")
                .font(.callout).foregroundColor(.secondary)
                .padding(.top, 16)

            Picker("Minutes", selection: $duree) {
                ForEach(1...300, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)
            .frame(height: 150)

            Text("Calories estimées : \(Int(caloriesBurned)) kcal")
                .font(.callout).fontWeight(.semibold)
                .padding(.top, 8)

            Spacer()

            // ── Actions ────────────────────────────────────────────
            VStack(spacing: 12) {
                Button {
                    guard !isSaving, let id = activite.id else { return }
                    Task { @MainActor in
                        isSaving = true
                        await contentViewModel.updateActivite(
                            id: id,
                            nom: activite.nom,
                            duree: Double(duree),
                            calorieBrulee: caloriesBurned
                        )
                        isSaving = false
                        dismiss()
                    }
                } label: {
                    ButtonAddView(text: isSaving ? "Mise à jour…" : "Mettre à jour")
                }
                .disabled(isSaving || isDeleting)

                Button {
                    guard !isDeleting, let id = activite.id else { return }
                    Task { @MainActor in
                        isDeleting = true
                        await contentViewModel.deleteActivite(id: id)
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
}
