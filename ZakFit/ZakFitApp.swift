import SwiftUI

@main
struct ZakFitApp: App {
    @StateObject private var contentViewModel = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentViewModel)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        Task { await contentViewModel.refreshIfNewDay() }
                    }
                }
        }
    }
}
