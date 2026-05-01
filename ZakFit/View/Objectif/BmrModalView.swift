import SwiftUI

struct BmrModalView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    @State private var tailleSelectionnee = 170
    @State private var poidsSelectionnee = 65
    @State private var ageSelectionnee = 25
    @State private var sexeSelectionne = 0   // 0 = Femme, 1 = Homme

    private var computedBmr: Double {
        if sexeSelectionne == 0 {
            return 655 + (9.6 * Double(poidsSelectionnee)) + (1.8 * Double(tailleSelectionnee)) - (4.7 * Double(ageSelectionnee))
        } else {
            return 66 + (13.7 * Double(poidsSelectionnee)) + (5 * Double(tailleSelectionnee)) - (6.8 * Double(ageSelectionnee))
        }
    }

    private var sexeString: String {
        sexeSelectionne == 0 ? "Femme" : "Homme"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text("Calcul du BMR")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Calcul basé sur le métabolisme basal")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }

                ageStepper
                sexePicker
                taillePicker
                poidsPicker

                Text("BMR estimé : \(Int(computedBmr.rounded())) Kcal/jour")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, Spacing.s)

                Button {
                    Task { await save() }
                } label: {
                    ButtonAddView(text: "Enregistrer")
                }
            }
            .padding(.horizontal, Spacing.l)
            .padding(.bottom, Spacing.l)
        }
        .onAppear { loadFromProfile() }
    }

    // MARK: - Controls

    private var ageStepper: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Âge")
                .font(.callout)
                .foregroundColor(.secondary)
            HStack {
                Spacer()
                Button {
                    if ageSelectionnee > 1 { ageSelectionnee -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.blue)
                }
                .frame(minWidth: 44, minHeight: 44)
                .accessibilityLabel("Diminuer l'âge")

                Spacer()
                Text("\(ageSelectionnee)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(minWidth: 60)
                Spacer()

                Button {
                    if ageSelectionnee < 120 { ageSelectionnee += 1 }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.blue)
                }
                .frame(minWidth: 44, minHeight: 44)
                .accessibilityLabel("Augmenter l'âge")
                Spacer()
            }
        }
    }

    private var sexePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Sexe")
                .font(.callout)
                .foregroundColor(.secondary)
            Picker("Sexe", selection: $sexeSelectionne) {
                Text("Femme").tag(0)
                Text("Homme").tag(1)
            }
            .pickerStyle(.segmented)
        }
    }

    private var taillePicker: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Taille (cm)")
                .font(.callout)
                .foregroundColor(.secondary)
            Picker("Taille", selection: $tailleSelectionnee) {
                ForEach(80...230, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
        }
    }

    private var poidsPicker: some View {
        VStack(alignment: .leading, spacing: Spacing.s) {
            Text("Poids (kg)")
                .font(.callout)
                .foregroundColor(.secondary)
            Picker("Poids", selection: $poidsSelectionnee) {
                ForEach(30...250, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)
            .frame(height: 120)
        }
    }

    // MARK: - Persistence

    private func loadFromProfile() {
        guard let bmr = contentViewModel.bmr else { return }
        if let p = bmr.poids   { poidsSelectionnee  = p }
        if let t = bmr.taille  { tailleSelectionnee = t }
        if let a = bmr.age     { ageSelectionnee    = a }
        if let s = bmr.sexe    { sexeSelectionne    = (s == "Homme") ? 1 : 0 }
    }

    private func save() async {
        await contentViewModel.saveBmr(
            poids: poidsSelectionnee,
            taille: tailleSelectionnee,
            age: ageSelectionnee,
            sexe: sexeString
        )
        await contentViewModel.setObjectifCalorie(calorie: Int(computedBmr.rounded()), nom: "BMR")
        dismiss()
    }
}

#Preview {
    BmrModalView()
        .environmentObject(ContentViewModel())
}
