import SwiftUI

struct AjoutObjectifCalorieView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    @State private var calorieSelectionnee = 2000

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Objectif personnalisé")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Choisis ton objectif calorique journalier")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: Spacing.s) {
                Text("Calories par jour")
                    .font(.callout)
                    .foregroundColor(.secondary)

                Picker("Calories", selection: $calorieSelectionnee) {
                    ForEach(Array(stride(from: 500, through: 4500, by: 10)), id: \.self) {
                        Text("\($0)")
                    }
                }
                .pickerStyle(.wheel)
            }

            Spacer()

            Button {
                Task {
                    await contentViewModel.setObjectifCalorie(calorie: calorieSelectionnee)
                    dismiss()
                }
            } label: {
                ButtonAddView(text: "Enregistrer")
            }
        }
        .padding(.horizontal, Spacing.l)
        .padding(.bottom, Spacing.l)
    }
}

#Preview {
    AjoutObjectifCalorieView()
        .environmentObject(ContentViewModel())
}
