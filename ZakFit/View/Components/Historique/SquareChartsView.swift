import SwiftUI

struct SquareChartsView: View {
    var text: String
    var color: Color

    var body: some View {
        HStack {
            Image(systemName: "square.fill")
                .foregroundColor(color)
            Text(text)
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    SquareChartsView(text: "Calories", color: .red)
}
