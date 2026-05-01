import SwiftUI

struct UserLoginView: View {
    @StateObject private var viewModel = UserLoginViewModel()
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Image(.zakFitLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())

                Text("Bon retour !")
                    .font(.title)

                Spacer()

                VStack(spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("Email")
                            .fontWeight(.regular)
                        TextField("Entrer votre email", text: $viewModel.email)
                            .modifier(TextFieldModifier())
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    }

                    VStack(alignment: .leading) {
                        Text("Mot de passe")
                            .fontWeight(.regular)
                        SecureField("Entrer votre mot de passe", text: $viewModel.mdp)
                            .modifier(TextFieldModifier())
                    }
                }
                .padding(.horizontal, 32)

                Spacer()

                Button {
                    Task { await viewModel.login(contentViewModel: contentViewModel) }
                } label: {
                    ButtonAddView(text: "Se connecter")
                }
                .padding(.horizontal, Spacing.xl)

                NavigationLink {
                    UserRegisterView()
                } label: {
                    Text("Vous n'avez pas de compte ? Enregistrez-vous")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(20)
            .alert(item: $viewModel.errorMessage) { errorMessage in
                Alert(
                    title: Text("Erreur"),
                    message: Text(errorMessage.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    UserLoginView()
        .environmentObject(ContentViewModel())
}
