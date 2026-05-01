import SwiftUI

struct ButtonActivity: View {
    var emoji: String

    var body: some View {
        Text(emoji)
            .font(.system(size: 30))
            .padding(10)
            .frame(width: 70, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.zakGray)
                    .opacity(0.6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 0.1)
            )
    }
}

#Preview {
    ButtonActivity(emoji: "💪")
}
