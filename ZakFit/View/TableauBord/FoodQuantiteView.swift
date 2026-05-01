import SwiftUI

struct FoodQuantiteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel

    let food: LocalFoodItem
    let categorie: LocalCategorieRepas

    @State private var grams: Int = 100
    @State private var isAdding: Bool = false

    private var calories: Int   { food.calories(forGrams: grams) }
    private var proteines: Int  { Int(food.proteine(forGrams: grams)) }
    private var lipides: Int    { Int(food.lipide(forGrams: grams)) }
    private var glucides: Int   { Int(food.glucide(forGrams: grams)) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 8) {
                Text(categorie.emoji)
                Text(categorie.nom)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 4)

            Text(food.nom)
                .font(.title2)
                .fontWeight(.semibold)

            Text("Préciser la quantité en grammes")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 4)

            Picker("Grammes", selection: $grams) {
                ForEach(1...1000, id: \.self) { g in
                    Text("\(g) g").tag(g)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 160)

            Text("Valeurs nutritionnelles")
                .font(.callout)
                .foregroundColor(.secondary)
                .padding(.top, 10)

            HStack(spacing: 8) {
                nutritionCard(value: calories,  label: "Kcal")
                nutritionCard(value: proteines, label: "Protéines")
                nutritionCard(value: glucides,  label: "Glucides")
                nutritionCard(value: lipides,   label: "Lipides")
            }
            .padding(.top, 16)

            Spacer()

            // Adds food to DB + local state, then pops back to the food list
            // so the user can add another food without closing the sheet.
            Button {
                guard !isAdding else { return }
                Task { @MainActor in
                    isAdding = true
                    await contentViewModel.addRepasFromLocal(
                        food: food,
                        grams: grams,
                        categorieRepasID: categorie.id
                    )
                    isAdding = false
                    dismiss()   // pop — sheet stays open
                }
            } label: {
                ButtonAddView(text: isAdding ? "Ajout en cours…" : "Ajouter")
            }
            .disabled(isAdding)
            .padding()
        }
        .padding(20)
    }

    private func nutritionCard(value: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FoodQuantiteView(
        food: .init(nom: "Avocat", caloriePer100g: 160, proteinePer100g: 2, lipidePer100g: 15, glucidePer100g: 9),
        categorie: MealCatalogue.categories[1]
    )
    .environmentObject(ContentViewModel())
}
