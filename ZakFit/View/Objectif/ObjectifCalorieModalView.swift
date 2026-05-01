import SwiftUI

struct ObjectifCalorieModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var mode: Mode = .bmr

    enum Mode: Hashable { case bmr, custom }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mode", selection: $mode) {
                    Text("Calcul BMR").tag(Mode.bmr)
                    Text("Personnalisé").tag(Mode.custom)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Spacing.l)
                .padding(.vertical, Spacing.s)

                Group {
                    switch mode {
                    case .bmr:    BmrModalView()
                    case .custom: AjoutObjectifCalorieView()
                    }
                }
            }
            .navigationTitle("Objectif calorique")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ObjectifCalorieModalView()
        .environmentObject(ContentViewModel())
}
