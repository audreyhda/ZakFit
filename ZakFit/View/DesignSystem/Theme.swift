import SwiftUI

enum Spacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
}

enum Radius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 20
}

enum Surface {
    /// Base card background — neutral, used for all cards.
    static let card = Color(.secondarySystemBackground)
    /// Subtle accent tint, applied as an inner chip / accent bar — never as the whole card.
    static let accentSoft = Color.lightGreen.opacity(0.25)
}
