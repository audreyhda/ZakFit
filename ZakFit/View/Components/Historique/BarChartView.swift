import SwiftUI
import Charts

struct BarChartView: View {
    enum Mode {
        case calories
        case activites
    }

    let historique: [HistoriqueDay]
    let mode: Mode
    /// Pass `true` in month view to shrink x-axis labels so 30+ day numbers fit.
    var smallLabels: Bool = false

    @State private var selectedLabel: String? = nil

    // MARK: - Derived data

    private var sortedAscending: [HistoriqueDay] {
        historique.sorted { $0.date < $1.date }
    }

    private var dayFormatter: DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        // Week view → abbreviated day name ("lun."), month view → day number ("1")
        f.dateFormat = historique.count <= 7 ? "EEE" : "d"
        return f
    }

    /// The `HistoriqueDay` matching the tapped x-axis label.
    private var selectedDay: HistoriqueDay? {
        guard let label = selectedLabel else { return nil }
        return sortedAscending.first { dayFormatter.string(from: $0.date) == label }
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Chart(sortedAscending) { day in
                let label  = dayFormatter.string(from: day.date)
                let dimmed = selectedLabel != nil && selectedLabel != label

                switch mode {
                case .calories:
                    BarMark(
                        x: .value("Jour", label),
                        y: .value("Calories totales", day.calorieTotale)
                    )
                    .foregroundStyle(.yellow)
                    .opacity(dimmed ? 0.30 : 1.0)

                    BarMark(
                        x: .value("Jour", label),
                        y: .value("Calories brûlées", day.calorieBrulee)
                    )
                    .foregroundStyle(.red)
                    .opacity(dimmed ? 0.30 : 1.0)

                case .activites:
                    BarMark(
                        x: .value("Jour", label),
                        y: .value("Activités", day.activitesCount)
                    )
                    .foregroundStyle(.blue)
                    .opacity(dimmed ? 0.30 : 1.0)

                    BarMark(
                        x: .value("Jour", label),
                        y: .value("Repas", day.repasCount)
                    )
                    .foregroundStyle(.green)
                    .opacity(dimmed ? 0.30 : 1.0)
                }
            }
            // ── Tap-to-select via overlay geometry (reliable for categorical axes) ──
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            guard let plotFrame = proxy.plotFrame else { return }
                            let frame    = geometry[plotFrame]
                            let xInPlot  = location.x - frame.minX
                            guard frame.width > 0,
                                  !sortedAscending.isEmpty,
                                  xInPlot >= 0,
                                  xInPlot <= frame.width
                            else { return }

                            // Divide plot width evenly across categories (categorical scale)
                            let binWidth = frame.width / CGFloat(sortedAscending.count)
                            let index    = max(0, min(sortedAscending.count - 1,
                                                      Int(xInPlot / binWidth)))
                            let day   = sortedAscending[index]
                            let label = dayFormatter.string(from: day.date)
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedLabel = (selectedLabel == label) ? nil : label
                            }
                        }
                }
            }
            .chartYAxis { AxisMarks(position: .leading) }
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let str = value.as(String.self) {
                            Text(str)
                                .font(smallLabels ? .system(size: 8) : .caption)
                        }
                    }
                }
            }
            .frame(height: 280)
            .padding()

            // ── Detail popup ──────────────────────────────────────────
            if let day = selectedDay {
                detailCard(for: day)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .top)))
            }

            // ── Legend ─────────────────────────────────────────────────
            HStack {
                switch mode {
                case .calories:
                    SquareChartsView(text: "Calories totales", color: .yellow)
                    SquareChartsView(text: "Calories brûlées", color: .red)
                case .activites:
                    SquareChartsView(text: "Activités", color: .blue)
                    SquareChartsView(text: "Repas",     color: .green)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Detail card

    @ViewBuilder
    private func detailCard(for day: HistoriqueDay) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(longLabel(for: day.date))
                    .font(.caption).fontWeight(.semibold)

                if day.hasData {
                    switch mode {
                    case .calories:
                        HStack(spacing: 14) {
                            Label("\(Int(day.calorieTotale)) kcal mangées", systemImage: "fork.knife")
                                .font(.caption2).foregroundColor(.secondary)
                            Label("\(Int(day.calorieBrulee)) kcal brûlées", systemImage: "flame.fill")
                                .font(.caption2).foregroundColor(.secondary)
                        }
                    case .activites:
                        HStack(spacing: 14) {
                            Label("\(day.activitesCount) activité(s)", systemImage: "figure.run")
                                .font(.caption2).foregroundColor(.secondary)
                            Label("\(Int(day.calorieBrulee)) kcal brûlées", systemImage: "flame.fill")
                                .font(.caption2).foregroundColor(.secondary)
                        }
                    }
                } else {
                    Text("Aucune entrée")
                        .font(.caption2).foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.15)) { selectedLabel = nil }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }

    private func longLabel(for date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "EEEE d MMMM"
        return f.string(from: date).capitalized
    }
}

#Preview {
    ScrollView {
        VStack {
            BarChartView(historique: HistoriqueDataSource.currentWeek(),  mode: .calories)
            BarChartView(historique: HistoriqueDataSource.currentMonth(), mode: .calories, smallLabels: true)
        }
    }
}
