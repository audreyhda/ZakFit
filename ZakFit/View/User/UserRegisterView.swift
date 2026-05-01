import SwiftUI

struct UserRegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = UserRegisterViewModel()
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        ScrollView {
            VStack {
                Image(.zakFitLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())

                Text("S'enregistrer")
                    .font(.title)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Nom")
                            .fontWeight(.regular)
                        TextField("Entrer votre nom", text: $viewModel.nom)
                            .modifier(TextFieldModifier())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading) {
                        Text("Prénom")
                            .fontWeight(.regular)
                        TextField("Entrer votre prénom", text: $viewModel.prenom)
                            .modifier(TextFieldModifier())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading) {
                        Text("Email")
                            .fontWeight(.regular)
                        TextField("Entrer votre email", text: $viewModel.email)
                            .modifier(TextFieldModifier())
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                    }

                    VStack(alignment: .leading) {
                        Text("Mot de passe")
                            .fontWeight(.regular)
                        SecureField("Entrer votre mot de passe", text: $viewModel.mdp)
                            .modifier(TextFieldModifier())
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 10)

                VStack(spacing: 8) {
                    Button {
                        Task { await viewModel.registration(contentViewModel: contentViewModel) }
                    } label: {
                        ButtonAddView(text: "S'enregistrer")
                    }

                    Button {
                        dismiss()
                    } label: {
                        Text("Vous avez déjà un compte ? Connectez-vous")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(20)
        }
        .navigationBarBackButtonHidden()
        .alert(item: $viewModel.errorMessage) { errorMessage in
            Alert(
                title: Text("Erreur"),
                message: Text(errorMessage.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    UserRegisterView()
        .environmentObject(ContentViewModel())
}
