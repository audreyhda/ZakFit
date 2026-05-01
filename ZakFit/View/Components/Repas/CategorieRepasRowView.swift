import SwiftUI

struct CategorieRepasRowView: View {
    let categorie: CategorieRepas
    @Binding var isPresented: Bool

    var body: some View {
        Button {
            isPresented = true
        } label: {
            VStack {
                ButtonAddRepas(emoji: categorie.emoji, isSelected: isPresented)
                Text(categorie.nom)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}
