import SwiftUI

struct ProfileView: View {
    @State private var showingSheet = false
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.l) {
                    HStack {
                        Text("Profil")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Modifier") { showingSheet = true }
                            .foregroundColor(.blue)
                            .fontWeight(.medium)
                            .sheet(isPresented: $showingSheet) {
                                ModifyProfileView()
                                    .environmentObject(contentViewModel)
                            }
                    }

                    identityCard
                    bodyCard
                }
                .padding(Spacing.l)
            }
        }
        .task {
            await contentViewModel.fetchCurrentUser()
            await contentViewModel.loadBmr()
        }
    }

    // MARK: - Cards

    private var identityCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Label("Identité", systemImage: "person.fill")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            VStack(spacing: 0) {
                infoRow(label: "Prénom", value: contentViewModel.currentUser?.prenom)
                Divider()
                infoRow(label: "Nom",    value: contentViewModel.currentUser?.nom)
                Divider()
                infoRow(label: "Email",  value: contentViewModel.currentUser?.email)
                Divider()
                infoRow(label: "Régime", value: contentViewModel.currentUser?.typeRegime)
            }
        }
        .card(tint: .blue)
    }

    private var bodyCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Label("Données corporelles", systemImage: "figure.stand")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)

            HStack(spacing: Spacing.m) {
                metricCell(
                    icon: "ruler",
                    value: contentViewModel.bmr?.taille.map { "\($0)" } ?? "—",
                    unit: "cm",
                    label: "Taille",
                    accent: .green
                )
                metricCell(
                    icon: "scalemass",
                    value: contentViewModel.bmr?.poids.map { "\($0)" } ?? "—",
                    unit: "kg",
                    label: "Poids",
                    accent: .orange
                )
                metricCell(
                    icon: "calendar",
                    value: contentViewModel.bmr?.age.map { "\($0)" } ?? "—",
                    unit: "ans",
                    label: "Âge",
                    accent: .pink
                )
            }
        }
        .card(tint: .green)
    }

    // MARK: - Cells

    private func infoRow(label: String, value: String?) -> some View {
        HStack {
            Text(label)
                .font(.callout)
                .foregroundColor(.secondary)
            Spacer()
            Text(value?.isEmpty == false ? value! : "—")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .padding(.vertical, Spacing.s)
    }

    private func metricCell(icon: String, value: String, unit: String, label: String, accent: Color) -> some View {
        VStack(spacing: Spacing.xs) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(accent)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.m)
        .background(
            RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
                .fill(accent.opacity(0.12))
        )
    }
}

#Preview {
    ProfileView()
        .environmentObject(ContentViewModel())
}
