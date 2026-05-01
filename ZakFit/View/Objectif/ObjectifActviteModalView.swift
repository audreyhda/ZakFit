import SwiftUI

struct ObjectifActviteModalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    @State private var selectedObjective: ObjectiveKind = .frequency
    @State private var frequencyPerWeek = 3
    @State private var dureeSelectionnee = 30
    @State private var calorieSelectionnee = 200

    enum ObjectiveKind: Hashable { case frequency, duration, calories }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.m) {
                    Text("Type d'objectif")
                        .font(.callout)
                        .foregroundColor(.secondary)

                    Picker("Type d'objectif", selection: $selectedObjective) {
                        Text("Fréquence").tag(ObjectiveKind.frequency)
                        Text("Durée").tag(ObjectiveKind.duration)
                        Text("Calories").tag(ObjectiveKind.calories)
                    }
                    .pickerStyle(.segmented)

                    switch selectedObjective {
                    case .frequency:
                        frequencyControl
                    case .duration:
                        durationControl
                    case .calories:
                        caloriesControl
                    }

                    Button {
                        Task { await save() }
                    } label: {
                        ButtonAddView(text: "Ajouter")
                    }
                    .padding(.top, Spacing.m)
                }
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.m)
            }
            .navigationTitle("Objectif d'activité")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }

    private var frequencyControl: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Fréquence d'entraînement par semaine")
                .font(.callout)
            HStack {
                Spacer()
                Button {
                    if frequencyPerWeek > 1 { frequencyPerWeek -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.blue)
                }
                .accessibilityLabel("Diminuer la fréquence")
                .frame(minWidth: 44, minHeight: 44)

                Spacer()
                Text("\(frequencyPerWeek)")
                    .font(.largeTitle).fontWeight(.bold)
                    .frame(minWidth: 60)
                Spacer()

                Button {
                    if frequencyPerWeek < 7 { frequencyPerWeek += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.blue)
                }
                .accessibilityLabel("Augmenter la fréquence")
                .frame(minWidth: 44, minHeight: 44)
                Spacer()
            }
            Text("séances / semaine").font(.caption).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var durationControl: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Durée des séances")
                .font(.callout)
            Picker("Minutes", selection: $dureeSelectionnee) {
                ForEach(1...300, id: \.self) { Text("\($0) min") }
            }
            .pickerStyle(.wheel)
        }
    }

    private var caloriesControl: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Calories à brûler")
                .font(.callout)
            Picker("Calories", selection: $calorieSelectionnee) {
                ForEach(50...1500, id: \.self) { Text("\($0) Kcal") }
            }
            .pickerStyle(.wheel)
        }
    }

    private func save() async {
        let nom: String
        switch selectedObjective {
        case .frequency: nom = "frequency"
        case .duration:  nom = "duration"
        case .calories:  nom = "calories"
        }
        let objectif = ObjectifActivite(
            id: nil,
            idUser: nil,
            nom: nom,
            calorie: selectedObjective == .calories ? calorieSelectionnee : nil,
            frequence: selectedObjective == .frequency ? frequencyPerWeek : nil,
            duree: selectedObjective == .duration ? dureeSelectionnee : nil,
            dateLimite: nil,
            etat: "actif"
        )
        await contentViewModel.addObjectifActivite(objectif)
        dismiss()
    }
}

#Preview {
    ObjectifActviteModalView()
        .environmentObject(ContentViewModel())
}
