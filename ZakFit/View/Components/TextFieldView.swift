import SwiftUI

struct TextFieldView: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.regular)
            TextField(placeholder, text: $text)
                .modifier(TextFieldModifier())
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
        }
    }
}
