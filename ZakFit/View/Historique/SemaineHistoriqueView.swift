import SwiftUI

struct SemaineHistoriqueView: View {
    let historique: [HistoriqueDay]

    @State private var showPastWeeks = false

    // MARK: - Week header  e.g. "5–11 mai 2026" or "28 avr. – 4 mai 2026"

    private var weekHeader: String {
        guard
            let first = historique.min(by: { $0.date < $1.date }),
            let last  = historique.max(by: { $0.date < $1.date })
        else { return "" }

        let cal       = Calendar.current
        let sameMonth = cal.component(.month, from: first.date) == cal.component(.month, from: last.date)

        if sameMonth {
            return "\(dateStr(first.date, "d"))–\(dateStr(last.date, "d MMMM yyyy"))"
        } else {
            return "\(dateStr(first.date, "d MMM")) – \(dateStr(last.date, "d MMM yyyy"))"
        }
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                // Header row: week range + previous-weeks button
                HStack {
                    if !weekHeader.isEmpty {
                        Text(weekHeader)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button {
                        showPastWeeks = true
                    } label: {
                        Label("Semaines précédentes", systemImage: "chevron.left.circle")
                            .font(.subheadline)
                    }
                }
                .padding(.bottom, 4)

                Text("Calories de la semaine")
                    .font(.title2).fontWeight(.semibold)

                BarChartView(historique: historique, mode: .calories)

                Text("Activités de la semaine")
                    .font(.title2).fontWeight(.semibold)
                    .padding(.top, 20)

                BarChartView(historique: historique, mode: .activites)
            }
        }
        .sheet(isPresented: $showPastWeeks) {
            PastWeeksView()
        }
    }

    // MARK: - Helpers

    private func dateStr(_ date: Date, _ format: String) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = format
        return f.string(from: date)
    }
}

// MARK: - Past weeks list

struct PastWeeksView: View {
    @Environment(\.dismiss) private var dismiss

    /// Last 12 weeks, each represented by a Monday of that week.
    private var pastMondayDates: [Date] {
        var iso = Calendar(identifier: .iso8601)
        iso.locale = Locale(identifier: "fr_FR")
        return (1...12).compactMap { offset -> Date? in
            guard let shifted = iso.date(byAdding: .weekOfYear, value: -offset, to: Date()) else { return nil }
            var comps = iso.dateComponents([.yearForWeekOfYear, .weekOfYear], from: shifted)
            comps.weekday = 2  // Monday
            return iso.date(from: comps)
        }
    }

    var body: some View {
        NavigationStack {
            List(pastMondayDates, id: \.self) { monday in
                let label = weekRangeLabel(monday: monday)
                NavigationLink(label.isEmpty ? "Semaine" : label) {
                    PastWeekChartView(monday: monday, title: label)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Semaines précédentes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }

    // MARK: - Label helpers

    /// "5–11 mai 2026" / "28 avr. – 4 mai 2026"
    private func weekRangeLabel(monday: Date) -> String {
        var iso = Calendar(identifier: .iso8601)
        iso.locale = Locale(identifier: "fr_FR")
        guard let sunday = iso.date(byAdding: .day, value: 6, to: monday) else { return "" }
        let cal       = Calendar.current
        let sameMonth = cal.component(.month, from: monday) == cal.component(.month, from: sunday)
        if sameMonth {
            return "\(dateStr(monday, "d"))–\(dateStr(sunday, "d MMMM yyyy"))"
        } else {
            return "\(dateStr(monday, "d MMM")) – \(dateStr(sunday, "d MMM yyyy"))"
        }
    }

    private func dateStr(_ date: Date, _ format: String) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = format
        return f.string(from: date)
    }
}

// MARK: - Chart view for a past week

struct PastWeekChartView: View {
    let monday: Date
    let title: String

    private var weekData: [HistoriqueDay] {
        HistoriqueDataSource.currentWeek(referenceDate: monday)
    }

    private var hasEntries: Bool {
        weekData.contains { $0.hasData }
    }

    var body: some View {
        Group {
            if hasEntries {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Calories de la semaine")
                            .font(.title2).fontWeight(.semibold)
                        BarChartView(historique: weekData, mode: .calories)

                        Text("Activités de la semaine")
                            .font(.title2).fontWeight(.semibold)
                            .padding(.top, 20)
                        BarChartView(historique: weekData, mode: .activites)
                    }
                    .padding()
                }
            } else {
                ContentUnavailableView(
                    "Aucune entrée",
                    systemImage: "calendar.badge.exclamationmark",
                    description: Text("Aucune activité ni repas enregistrés pour cette semaine.")
                )
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SemaineHistoriqueView(historique: HistoriqueDataSource.currentWeek())
}
