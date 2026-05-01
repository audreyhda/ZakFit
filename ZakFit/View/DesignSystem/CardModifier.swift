import SwiftUI

struct CardModifier: ViewModifier {
    var tint: Color? = nil

    func body(content: Content) -> some View {
        content
            .padding(Spacing.m)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: Radius.large, style: .continuous)
                        .fill(Surface.card)
                    if let tint {
                        RoundedRectangle(cornerRadius: Radius.large, style: .continuous)
                            .fill(tint.opacity(0.18))
                    }
                }
            )
    }
}

extension View {
    /// Applies a neutral card surface, optionally with a soft accent tint.
    func card(tint: Color? = nil) -> some View {
        modifier(CardModifier(tint: tint))
    }
}
