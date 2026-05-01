import SwiftUI

struct CircularProgressView: View {
    let progress: CGFloat
    var color: Color
    var text: String

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 7)
                    .opacity(0.4)
                    .foregroundColor(.zakGray)

                Circle()
                    .trim(from: 0.0, to: min(progress, 1.0))
                    .stroke(style: StrokeStyle(lineWidth: 7, lineCap: .round, lineJoin: .round))
                    .foregroundColor(color)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear, value: progress)
            }
            Text(text)
                .font(.footnote)
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.6, color: .blue, text: "progress")
}
