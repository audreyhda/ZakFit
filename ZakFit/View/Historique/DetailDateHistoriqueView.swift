import SwiftUI

struct DetailDateHistoriqueView: View {
    let day: HistoriqueDay
    @EnvironmentObject var contentViewModel: ContentViewModel

    /// For today, surface live values from the ViewModel so any new repas/activité
    /// shows up without needing to navigate back. Past/future days use the captured snapshot.
    private var effectiveDay: HistoriqueDay {
        guard Calendar.current.isDateInToday(day.date) else { return day }
        return HistoriqueDay(
            date: day.date,
            calorieTotale:  Double(contentViewModel.caloriesEaten),
            calorieBrulee:  Double(contentViewModel.caloriesBurned),
            proteine:       contentViewModel.totalProteine,
            lipide:         contentViewModel.totalLipide,
            glucide:        contentViewModel.totalGlucide,
            activitesCount: contentViewModel.todayActivites.count,
            repasCount:     contentViewModel.todayRepas.count
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.l) {
                Text(effectiveDay.date, style: .date)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                caloriesCard
                macrosCard
                volumesCard
            }
            .padding(Spacing.l)
        }
    }

    // MARK: - Sections

    private var caloriesCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Label("Calories", systemImage: "flame.fill")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .labelStyle(.titleAndIcon)

            HStack(spacing: Spacing.m) {
                summaryCell(
                    value: "\(Int(effectiveDay.calorieTotale))",
                    label: "Mangées",
                    accent: .green
                )
                summaryCell(
                    value: "\(Int(effectiveDay.calorieBrulee))",
                    label: "Brûlées",
                    accent: .orange
                )
                summaryCell(
                    value: "\(Int(max(0, effectiveDay.calorieTotale - effectiveDay.calorieBrulee)))",
                    label: "Net",
                    accent: .blue
                )
            }
        }
        .card(tint: .green)
    }

    private var macrosCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Label("Macronutriments", systemImage: "fork.knife")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .labelStyle(.titleAndIcon)

            HStack(spacing: Spacing.m) {
                summaryCell(
                    value: "\(Int(effectiveDay.proteine)) g",
                    label: "Protéines",
                    accent: .red
                )
                summaryCell(
                    value: "\(Int(effectiveDay.lipide)) g",
                    label: "Lipides",
                    accent: .yellow
                )
                summaryCell(
                    value: "\(Int(effectiveDay.glucide)) g",
                    label: "Glucides",
                    accent: .blue
                )
            }
        }
        .card(tint: .orange)
    }

    private var volumesCard: some View {
        VStack(alignment: .leading, spacing: Spacing.m) {
            Label("Volumes", systemImage: "chart.bar.fill")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .labelStyle(.titleAndIcon)

            HStack(spacing: Spacing.m) {
                summaryCell(
                    value: "\(effectiveDay.repasCount)",
                    label: "Repas",
                    accent: .pink
                )
                summaryCell(
                    value: "\(effectiveDay.activitesCount)",
                    label: "Activités",
                    accent: .purple
                )
            }
        }
        .card(tint: .blue)
    }

    // MARK: - Cells

    private func summaryCell(value: String, label: String, accent: Color) -> some View {
        VStack(spacing: Spacing.xs) {
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(accent)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s)
        .background(
            RoundedRectangle(cornerRadius: Radius.medium, style: .continuous)
                .fill(accent.opacity(0.12))
        )
    }
}

#Preview {
    DetailDateHistoriqueView(day: HistoriqueDataSource.lastMonth().first!)
        .environmentObject(ContentViewModel())
}
