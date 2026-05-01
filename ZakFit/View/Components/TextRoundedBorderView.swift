import SwiftUI

struct TextRoundedBorderView: View {
    var title: String
    var text: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 1)
                )
        }
    }
}
