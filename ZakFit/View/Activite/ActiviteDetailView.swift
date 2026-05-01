import SwiftUI

struct ActiviteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    let activite: Activite
    var onDismiss: (() -> Void)? = nil

    @State private var dureeSelectionnee = 20
    @State private var caloriesBurned: Double = 0

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ajouter une activité")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Préciser la durée")
                .font(.callout)
                .fontWeight(.light)

            Spacer()

            ButtonTextActivityView(emoji: activite.emoji, text: activite.nom)
                .padding(.top, 10)

            Spacer()

            Text("Durée en minutes")
                .font(.callout)
                .fontWeight(.light)
                .padding(.top, 10)

            Picker("Minutes", selection: $dureeSelectionnee) {
                ForEach(1...300, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)
            .onChange(of: dureeSelectionnee) { _, _ in
                calculateCalories()
            }

            Text("Calories estimées : \(Int(caloriesBurned)) Kcal")
                .font(.callout)
                .fontWeight(.semibold)
                .padding(.top, 10)

            Spacer()

            Button {
                Task {
                    calculateCalories()
                    await contentViewModel.addActivite(
                        nom: activite.nom,
                        duree: Double(dureeSelectionnee),
                        calorieBrulee: caloriesBurned
                    )
                    if let onDismiss {
                        onDismiss()
                    } else {
                        dismiss()
                    }
                }
            } label: {
                ButtonAddView(text: "Ajouter")
            }
            .padding()
        }
        .padding(20)
        .onAppear { calculateCalories() }
    }

    private func calculateCalories() {
        let perMinute = activite.calorieBrulee ?? 0
        caloriesBurned = perMinute * Double(dureeSelectionnee)
    }
}

#Preview {
    ActiviteDetailView(activite: Activite(id: nil, idUtilisateur: nil, nom: "Force", dateActivite: nil, calorieBrulee: 6.0, duree: 10))
        .environmentObject(ContentViewModel())
}
