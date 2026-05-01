import SwiftUI

enum Tab: String {
    case home = "gauge.with.dots.needle.67percent"
    case historique = "chart.line.uptrend.xyaxis"
    case objectif = "target"
    case profile = "person"
}

struct TabBarView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            TableauBordView()
                .tabItem {
                    Image(systemName: Tab.home.rawValue)
                    Text("Tableau de bord")
                }
                .tag(Tab.home)

            HistoriqueView()
                .tabItem {
                    Image(systemName: Tab.historique.rawValue)
                    Text("Historique")
                }
                .tag(Tab.historique)

            ObjectifView()
                .tabItem {
                    Image(systemName: Tab.objectif.rawValue)
                    Text("Objectif")
                }
                .tag(Tab.objectif)

            ProfileView()
                .tabItem {
                    Image(systemName: Tab.profile.rawValue)
                    Text("Profil")
                }
                .tag(Tab.profile)
        }
    }
}

#Preview {
    TabBarView()
        .environmentObject(ContentViewModel())
}
