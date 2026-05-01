import SwiftUI

struct ListRowHistoriqueView: View {
    var date: Date
    var calorieTotale: Double
    var calorieBrulee: Double

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(dateFormatter.string(from: date))
                Text("\(String(format: "%.1f", calorieTotale)) Kcal totales")
                    .font(.footnote)
                Text("\(String(format: "%.1f", calorieBrulee)) Kcal brûlées")
                    .font(.footnote)
            }
            Spacer()
        }
    }
}

#Preview {
    ListRowHistoriqueView(date: Date.now, calorieTotale: 2000, calorieBrulee: 500)
}
