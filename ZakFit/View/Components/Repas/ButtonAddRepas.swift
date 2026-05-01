import SwiftUI

struct ButtonAddRepas: View {
    var emoji: String
    var isSelected: Bool = false

    var body: some View {
        Text(emoji)
            .font(.system(size: 40))
            .padding(10)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ButtonAddRepas(emoji: "🥗")
}
