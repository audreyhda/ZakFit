import SwiftUI

struct DateHistoriqueView: View {
    let historique: [HistoriqueDay]
    @State private var isAscending = false
    @State private var searchText = ""

    private var filtered: [HistoriqueDay] {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let sorted = historique.sorted(by: isAscending ? { $0.date < $1.date } : { $0.date > $1.date })
        guard !searchText.isEmpty else { return sorted }
        return sorted.filter { formatter.string(from: $0.date).localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    isAscending.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 10)

            List(filtered) { day in
                NavigationLink(destination: DetailDateHistoriqueView(day: day)) {
                    ListRowHistoriqueView(
                        date: day.date,
                        calorieTotale: day.calorieTotale,
                        calorieBrulee: day.calorieBrulee
                    )
                }
            }
            .listStyle(.plain)
        }
//        .searchable(text: $searchText)
    }
}

#Preview {
    NavigationStack {
        DateHistoriqueView(historique: HistoriqueDataSource.lastMonth())
    }
}
