import SwiftUI

/// Primary CTA label. Pair with `.buttonStyle(.primary)` on a `Button`,
/// or use directly inside a `Button { ... } label: { ButtonAddView(text: "...") }`
/// — both styles render identically.
struct ButtonAddView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: Radius.small, style: .continuous))
    }
}

#Preview {
    ButtonAddView(text: "Ajouter")
        .padding()
}
