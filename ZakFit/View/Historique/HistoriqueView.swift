import SwiftUI

struct HistoriqueView: View {
    @State private var segmentedPickerChoice = 0
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Historique")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Picker("", selection: $segmentedPickerChoice) {
                    Text("Semaine").tag(0)
                    Text("Mois").tag(1)
                    Text("Date").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()

                Group {
                    if segmentedPickerChoice == 0 {
                        SemaineHistoriqueView(historique: weekData)
                    } else if segmentedPickerChoice == 1 {
                        MoisHistoriqueView(historique: monthData)
                    } else {
                        DateHistoriqueView(historique: dateData)
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding()
        }
    }

    // MARK: - Today's real entries (from ContentViewModel)

    private var todayData: HistoriqueDataSource.TodayData {
        HistoriqueDataSource.TodayData(
            calorieTotale:  Double(contentViewModel.caloriesEaten),
            calorieBrulee:  Double(contentViewModel.caloriesBurned),
            proteine:       contentViewModel.totalProteine,
            lipide:         contentViewModel.totalLipide,
            glucide:        contentViewModel.totalGlucide,
            activitesCount: contentViewModel.todayActivites.count,
            repasCount:     contentViewModel.todayRepas.count
        )
    }

    // MARK: - Chart data

    /// Mon–Sun of the current ISO week.
    /// Past days → fake seeded data. Today → real entries. Future → empty bars.
    private var weekData: [HistoriqueDay] {
        HistoriqueDataSource.currentWeek(today: todayData,
                                         goal: contentViewModel.calorieGoal)
    }

    /// All days of the current calendar month (same data rules as weekData).
    private var monthData: [HistoriqueDay] {
        HistoriqueDataSource.currentMonth(today: todayData,
                                          goal: contentViewModel.calorieGoal)
    }

    /// Last 30 days for the "Date" tab — past days get deterministic fake data,
    /// today gets the live values from the ViewModel, future days are empty.
    private var dateData: [HistoriqueDay] {
        HistoriqueDataSource.lastMonth(today: todayData,
                                       goal: contentViewModel.calorieGoal)
    }
}

#Preview {
    HistoriqueView()
        .environmentObject(ContentViewModel())
}
