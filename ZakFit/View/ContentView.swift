import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
        if contentViewModel.isAuthenticated {
            TabBarView()
        } else {
            UserLoginView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ContentViewModel())
}
