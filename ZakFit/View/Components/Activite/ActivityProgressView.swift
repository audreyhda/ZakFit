import SwiftUI

struct ActivityProgressView: View {
    let progress: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 40)
                .opacity(0.1)
                .foregroundStyle(color)

            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(style: StrokeStyle(lineWidth: 40, lineCap: .round))
                .foregroundStyle(color)
                .rotationEffect(.degrees(-90))
        }
    }
}

#Preview {
    ActivityProgressView(progress: 0.6, color: .blue)
}
