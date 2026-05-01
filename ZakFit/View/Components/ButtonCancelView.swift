import SwiftUI

/// Destructive CTA label (logout, delete). Use sparingly — never for primary actions.
struct ButtonCancelView: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.body.weight(.semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.m)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: Radius.small, style: .continuous))
    }
}

#Preview {
    ButtonCancelView(text: "Supprimer")
        .padding()
}
