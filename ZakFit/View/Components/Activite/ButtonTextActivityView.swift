import SwiftUI

struct ButtonTextActivityView: View {
    var emoji: String
    var text: String

    var body: some View {
        HStack {
            ButtonActivity(emoji: emoji)
            Text(text)
                .font(.title2)
                .fontWeight(.medium)
                .padding(.leading, 20)
        }
    }
}

#Preview {
    ButtonTextActivityView(emoji: "💪", text: "Force")
}
