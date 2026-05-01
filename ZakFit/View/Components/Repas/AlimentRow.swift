import SwiftUI

struct AlimentRow: View {
    var text: String

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "plus.circle")
                .foregroundStyle(Color.blue)
                .font(.system(size: 26))
            Text(text)
                .font(.title3)
                .foregroundStyle(Color.black)
        }
    }
}

#Preview {
    AlimentRow(text: "Avocat")
}
