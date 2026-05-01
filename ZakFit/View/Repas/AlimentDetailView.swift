import SwiftUI

struct AlimentDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    let aliment: Aliment
    let idCategorieRepas: UUID

    @State private var quantiteSelectionnee = 100

    private var calories: Int { ((aliment.calorie ?? 0) * quantiteSelectionnee) / 100 }
    private var proteines: Int { Int(((aliment.proteine ?? 0) * Double(quantiteSelectionnee)) / 100) }
    private var glucides: Int { Int(((aliment.glucide ?? 0) * Double(quantiteSelectionnee)) / 100) }
    private var lipides: Int { Int(((aliment.lipide ?? 0) * Double(quantiteSelectionnee)) / 100) }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ajouter un aliment")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Préciser la quantité en grammes")
                .font(.callout)
                .fontWeight(.light)

            Picker("Grammes", selection: $quantiteSelectionnee) {
                ForEach(1...1000, id: \.self) { Text("\($0)") }
            }
            .pickerStyle(.wheel)

            Spacer()

            Text("Nutrition")
                .font(.callout)
                .fontWeight(.light)
                .padding(.top, 10)

            HStack(spacing: 20) {
                nutritionCard(value: calories, label: "Calories")
                nutritionCard(value: proteines, label: "Protéines")
                nutritionCard(value: glucides, label: "Glucides")
                nutritionCard(value: lipides, label: "Lipides")
            }
            .padding(.top, 30)

            Spacer()

            Button {
                Task { await addAliment() }
            } label: {
                ButtonAddView(text: "Ajouter")
            }
            .padding()
        }
        .padding(20)
    }

    private func addAliment() async {
        guard let alimentID = aliment.id else { return }
        await contentViewModel.addRepas(idAliment: alimentID, idCategorieRepas: idCategorieRepas)
        dismiss()
    }

    private func nutritionCard(value: Int, label: String) -> some View {
        VStack {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .padding(.top, 5)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    AlimentDetailView(
        aliment: Aliment(id: UUID(), nom: "Avocat", quantite: 100, calorie: 290, proteine: 2, glucide: 10, lipide: 200),
        idCategorieRepas: UUID()
    )
    .environmentObject(ContentViewModel())
}
