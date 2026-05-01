import SwiftUI

struct AlimentCategorieView: View {
    let aliments: [Aliment]
    let idCategorieRepas: UUID

    @State private var searchText = ""

    private var filtered: [Aliment] {
        guard !searchText.isEmpty else { return aliments }
        return aliments.filter { ($0.nom ?? "").localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List(filtered) { aliment in
            NavigationLink(destination: AlimentDetailView(aliment: aliment, idCategorieRepas: idCategorieRepas)) {
                AlimentRow(text: aliment.nom ?? "")
            }
        }
        .listStyle(.plain)
        .searchable(text: $searchText)
    }
}

#Preview {
    AlimentCategorieView(aliments: [], idCategorieRepas: UUID())
}
