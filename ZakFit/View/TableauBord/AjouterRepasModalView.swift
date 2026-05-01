import SwiftUI

struct AjouterRepasModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var contentViewModel: ContentViewModel

    @State private var selectedIndex: Int = 0
    @State private var searchText: String = ""

    private var selectedCategorie: LocalCategorieRepas {
        MealCatalogue.categories[selectedIndex]
    }

    private var filteredFoods: [LocalFoodItem] {
        guard !searchText.isEmpty else { return WholeFoodCatalogue.all }
        return WholeFoodCatalogue.all.filter {
            $0.nom.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category tabs — hardcoded, no server call
                Picker("", selection: $selectedIndex) {
                    ForEach(Array(MealCatalogue.categories.enumerated()), id: \.offset) { idx, cat in
                        Text("\(cat.emoji) \(cat.nom)").tag(idx)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Today's meal count badge
                let count = contentViewModel.todayRepas.count
                if count > 0 {
                    Text("\(count) aliment(s) ajouté(s) aujourd'hui")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                }

                // Food list
                List(filteredFoods) { food in
                    NavigationLink {
                        FoodQuantiteView(
                            food: food,
                            categorie: selectedCategorie
                        )
                        .environmentObject(contentViewModel)
                    } label: {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(food.nom)
                                .font(.body)
                            Text("\(food.caloriePer100g) kcal / 100 g")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Ajouter un repas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { isPresented = false }
                }
            }
            .searchable(text: $searchText, prompt: "Rechercher un aliment")
        }
    }
}

#Preview {
    AjouterRepasModalView(isPresented: .constant(true))
        .environmentObject(ContentViewModel())
}
