import SwiftUI

struct ActiviteView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel

    private static let catalogue: [Activite] = [
        Activite(id: nil, idUtilisateur: nil, nom: "Force", dateActivite: nil, calorieBrulee: 6.0, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Yoga", dateActivite: nil, calorieBrulee: 4.0, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Vélo", dateActivite: nil, calorieBrulee: 7.0, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Natation", dateActivite: nil, calorieBrulee: 7.5, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "HIIT", dateActivite: nil, calorieBrulee: 10.0, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Marche", dateActivite: nil, calorieBrulee: 4.25, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Autre", dateActivite: nil, calorieBrulee: 0, duree: 10)
    ]

    var body: some View {
        List {
            ForEach(Self.catalogue) { activite in
                NavigationLink(destination: destination(for: activite)) {
                    ButtonTextActivityView(emoji: activite.emoji, text: activite.nom)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.white.ignoresSafeArea())
    }

    @ViewBuilder
    private func destination(for activite: Activite) -> some View {
        if activite.nom == "Autre" {
            AutreActiviteDetailView()
        } else {
            ActiviteDetailView(activite: activite)
        }
    }
}

#Preview {
    NavigationStack {
        ActiviteView()
    }
    .environmentObject(ContentViewModel())
}
