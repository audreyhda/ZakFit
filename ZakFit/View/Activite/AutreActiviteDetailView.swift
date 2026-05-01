import SwiftUI

struct AutreActiviteDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    var onDismiss: (() -> Void)? = nil

    @State private var nom: String = ""
    @State private var dureeSelectionnee = 20
    @State private var calorieSelectionnee = 100

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ajouter une activité")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Préciser le nom et la durée")
                .font(.callout)
                .fontWeight(.light)

            ButtonTextActivityView(emoji: "❓", text: "Autre")
                .padding(.top, 10)

            Spacer()

            VStack(alignment: .leading) {
                Text("Nom")
                    .fontWeight(.regular)
                TextField("Nom de l'activité", text: $nom)
                    .modifier(TextFieldModifier())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Spacer()

            Text("Durée en minutes")
                .font(.callout)
                .fontWeight(.light)
                .padding(.top, 10)

            Picker("Minutes", selection: $dureeSelectionnee) {
                ForEach(1...300, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)

            Spacer()

            Text("Calories brûlées (Kcal)")
                .font(.callout)
                .fontWeight(.light)
                .padding(.top, 10)

            Picker("Calories", selection: $calorieSelectionnee) {
                ForEach(1...1500, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)

            Spacer()

            Button {
                Task {
                    await contentViewModel.addActivite(
                        nom: nom.isEmpty ? "Autre" : nom,
                        duree: Double(dureeSelectionnee),
                        calorieBrulee: Double(calorieSelectionnee)
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
        .padding(30)
    }
}

#Preview {
    AutreActiviteDetailView()
        .environmentObject(ContentViewModel())
}
