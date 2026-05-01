import SwiftUI

struct AjouterActiviteModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var contentViewModel: ContentViewModel

    private static let catalogue: [Activite] = [
        Activite(id: nil, idUtilisateur: nil, nom: "Force",    dateActivite: nil, calorieBrulee: 6.0,  duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Yoga",     dateActivite: nil, calorieBrulee: 4.0,  duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Vélo",     dateActivite: nil, calorieBrulee: 7.0,  duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Natation", dateActivite: nil, calorieBrulee: 7.5,  duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "HIIT",     dateActivite: nil, calorieBrulee: 10.0, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Marche",   dateActivite: nil, calorieBrulee: 4.25, duree: 10),
        Activite(id: nil, idUtilisateur: nil, nom: "Autre",    dateActivite: nil, calorieBrulee: 0,    duree: 10)
    ]

    var body: some View {
        NavigationStack {
            List(Self.catalogue, id: \.nom) { activite in
                NavigationLink {
                    destinationView(for: activite)
                        .environmentObject(contentViewModel)
                } label: {
                    HStack(spacing: 14) {
                        Text(activite.emoji)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(activite.nom)
                                .font(.body)
                            if activite.nom != "Autre" {
                                Text("\(Int((activite.calorieBrulee ?? 0) * 20)) kcal pour 20 min")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Ajouter une activité")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { isPresented = false }
                }
            }
        }
    }

    @ViewBuilder
    private func destinationView(for activite: Activite) -> some View {
        if activite.nom == "Autre" {
            AutreActiviteDetailView(onDismiss: { isPresented = false })
        } else {
            ActiviteDetailView(activite: activite, onDismiss: { isPresented = false })
        }
    }
}

#Preview {
    AjouterActiviteModalView(isPresented: .constant(true))
        .environmentObject(ContentViewModel())
}
