// This line imports SwiftUI, a framework developed by Apple for building user interfaces across all Apple devices.
import SwiftUI

// This line imports BackgroundTasks, a framework developed by Apple that allows you to schedule tasks to be run in the background, even when your app isn't running.
import BackgroundTasks

// This is the main entry point for your app. The `@main` attribute identifies HabitMasterApp's main structure.
@main
struct HabitMasterApp: App {
    // This line creates an instance of `CustomAppDelegate`. The `UIApplicationDelegateAdaptor` attribute allows you to integrate AppDelegate methods within SwiftUI's new App lifecycle.
    @UIApplicationDelegateAdaptor(CustomAppDelegate.self) var appDelegate

    // This line creates an instance of `StepCountViewModel` as a `StateObject`. `@StateObject` is a property wrapper that ensures the instance isn't recreated across new View updates.
    @StateObject private var stepCountViewModel = StepCountViewModel()

    // This is the main body of your app.
    var body: some Scene {
        // `WindowGroup` is a container that you use when you want your app to support multiple instances of your app's functionality.
        WindowGroup {
            // `HomeView` is displayed here and it is passed two environment objects, `habitListViewModel` from `appDelegate` and `stepCountViewModel`.
            // The `environmentObject(_:)` modifier is used to provide an observable object to a view hierarchy.
            HomeView()
                .environmentObject(appDelegate.habitListViewModel)
                .environmentObject(stepCountViewModel)
        }
    }
}





