import SwiftUI

struct MoisHistoriqueView: View {
    let historique: [HistoriqueDay]

    @State private var showPastMonths = false

    // MARK: - Month header  e.g. "Mai 2026"

    private var monthHeader: String {
        guard let first = historique.min(by: { $0.date < $1.date }) else { return "" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: first.date).capitalized
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                // Header row: month name + previous-months button
                HStack {
                    if !monthHeader.isEmpty {
                        Text(monthHeader)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        showPastMonths = true
                    } label: {
                        Label("Mois précédents", systemImage: "chevron.left.circle")
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 4)

                Text("Calories du mois")
                    .font(.title2).fontWeight(.semibold)

                BarChartView(historique: historique, mode: .calories, smallLabels: true)

                Text("Activités du mois")
                    .font(.title2).fontWeight(.semibold)
                    .padding(.top, 20)

                BarChartView(historique: historique, mode: .activites, smallLabels: true)
            }
        }
        .sheet(isPresented: $showPastMonths) {
            PastMonthsView()
        }
    }
}

// MARK: - Past months list

struct PastMonthsView: View {
    @Environment(\.dismiss) private var dismiss

    /// First day of each of the last 12 months (not including the current month).
    private var pastFirstDays: [Date] {
        let cal = Calendar.current
        return (1...12).compactMap { offset -> Date? in
            guard
                let shifted = cal.date(byAdding: .month, value: -offset, to: Date()),
                let first   = cal.date(from: cal.dateComponents([.year, .month], from: shifted))
            else { return nil }
            return first
        }
    }

    var body: some View {
        NavigationStack {
            List(pastFirstDays, id: \.self) { firstDay in
                let label = monthLabel(firstDay)
                NavigationLink(label) {
                    PastMonthChartView(firstDay: firstDay, title: label)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Mois précédents")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }

    private func monthLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "MMMM yyyy"
        return f.string(from: date).capitalized
    }
}

// MARK: - Chart view for a past month

struct PastMonthChartView: View {
    let firstDay: Date
    let title: String

    private var monthData: [HistoriqueDay] {
        HistoriqueDataSource.currentMonth(referenceDate: firstDay)
    }

    private var hasEntries: Bool {
        monthData.contains { $0.hasData }
    }

    var body: some View {
        Group {
            if hasEntries {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Calories du mois")
                            .font(.title2).fontWeight(.semibold)
                        BarChartView(historique: monthData, mode: .calories, smallLabels: true)

                        Text("Activités du mois")
                            .font(.title2).fontWeight(.semibold)
                            .padding(.top, 20)
                        BarChartView(historique: monthData, mode: .activites, smallLabels: true)
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView(
                    "Aucune entrée",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Aucune activité ni repas enregistrés pour ce mois.")
                )
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MoisHistoriqueView(historique: HistoriqueDataSource.currentMonth())
}
