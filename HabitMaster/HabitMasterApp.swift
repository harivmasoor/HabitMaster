import SwiftUI
import BackgroundTasks

@main
struct HabitMasterApp: App {
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appDelegate.habitListViewModel)
        }
    }
}



