import SwiftUI

struct ModifyProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var contentViewModel: ContentViewModel
    @StateObject private var viewModel = ProfileViewModel()

    private let typesRegime = ["Standard", "Végétarien", "Végan", "Sans lactose", "Sans gluten"]
    private let objectifsPoids = ["Perte", "Maintien", "Prise"]
    @State private var selectedObjectifPoids = "Maintien"
    @State private var showLogoutConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        Button("Annuler") { dismiss() }
                            .foregroundColor(.gray)
                        Spacer()
                        Button("Valider") {
                            Task {
                                await viewModel.update(contentViewModel: contentViewModel)
                                dismiss()
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    VStack(spacing: 12) {
                        labeledField("Nom", text: $viewModel.nom)
                        labeledField("Prénom", text: $viewModel.prenom)
                        labeledField("Email", text: $viewModel.email, keyboard: .emailAddress)
                        VStack(alignment: .leading) {
                            Text("Mot de passe")
                                .fontWeight(.regular)
                            SecureField("Laisser vide pour conserver", text: $viewModel.mdp)
                                .modifier(TextFieldModifier())
                        }

                        VStack(alignment: .leading) {
                            Text("Taille en cm")
                                .fontWeight(.regular)
                            Slider(value: $viewModel.taille, in: 100...230, step: 1)
                            Text("\(Int(viewModel.taille))")
                        }

                        VStack(alignment: .leading) {
                            Text("Poids en kg")
                                .fontWeight(.regular)
                            Slider(value: $viewModel.poids, in: 40...200, step: 1)
                            Text("\(Int(viewModel.poids))")
                        }

                        Stepper("Âge : \(viewModel.age)", value: $viewModel.age, in: 12...120)

                        HStack {
                            Text("Régime alimentaire")
                            Spacer()
                            Picker("Régime alimentaire", selection: $viewModel.typeRegime) {
                                Text("—").tag("")
                                ForEach(typesRegime, id: \.self) { Text($0).tag($0) }
                            }
                        }

                        HStack {
                            Text("Objectif de poids")
                            Spacer()
                            Picker("Objectif de poids", selection: $selectedObjectifPoids) {
                                ForEach(objectifsPoids, id: \.self) { Text($0) }
                            }
                        }
                    }
                    .padding(.horizontal, 32)

                    Button {
                        showLogoutConfirmation = true
                    } label: {
                        ButtonCancelView(text: "Se déconnecter")
                    }
                    .padding(.horizontal, 32)
                    .alert(isPresented: $showLogoutConfirmation) {
                        Alert(
                            title: Text("Se déconnecter"),
                            message: Text("Êtes-vous sûr de vouloir vous déconnecter ?"),
                            primaryButton: .destructive(Text("Se déconnecter")) {
                                contentViewModel.logout()
                                dismiss()
                            },
                            secondaryButton: .cancel(Text("Annuler"))
                        )
                    }
                }
                .padding(.top, 20)
            }
        }
        .task {
            viewModel.load(from: contentViewModel)
        }
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(title: Text("Erreur"), message: Text(errorMessage.message), dismissButton: .default(Text("OK")))
        }
    }

    private func labeledField(_ title: String, text: Binding<String>, keyboard: UIKeyboardType = .default) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.regular)
            TextField(title, text: text)
                .modifier(TextFieldModifier())
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .keyboardType(keyboard)
        }
    }
}

#Preview {
    ModifyProfileView()
        .environmentObject(ContentViewModel())
}
