import SwiftUI

struct AlimentView: View {
    let idCategorieRepas: UUID

    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var segmentedPickerValue = 0
    @State private var searchText = ""

    private var filteredAliments: [Aliment] {
        let aliments = contentViewModel.aliments
        guard !searchText.isEmpty else { return aliments }
        return aliments.filter {
            ($0.nom ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack {
            Picker("", selection: $segmentedPickerValue) {
                Text("Récent").tag(0)
                Text("Par catégorie").tag(1)
            }
            .pickerStyle(.segmented)
            .padding()

            if segmentedPickerValue == 0 {
                List(filteredAliments) { aliment in
                    NavigationLink(destination: AlimentDetailView(aliment: aliment, idCategorieRepas: idCategorieRepas)) {
                        AlimentRow(text: aliment.nom ?? "")
                    }
                }
                .listStyle(.plain)
            } else {
                List(contentViewModel.categoriesAliment) { categorie in
                    let aliments = filteredAliments.filter { $0.idCategorieAliment == categorie.id }
                    NavigationLink(destination: AlimentCategorieView(aliments: aliments, idCategorieRepas: idCategorieRepas)) {
                        AlimentRow(text: categorie.nom ?? "")
                    }
                }
                .listStyle(.plain)
            }
        }
        .task {
            if contentViewModel.aliments.isEmpty {
                await contentViewModel.loadCatalogue()
            }
        }
        .searchable(text: $searchText)
    }
}

#Preview {
    AlimentView(idCategorieRepas: UUID())
        .environmentObject(ContentViewModel())
}
