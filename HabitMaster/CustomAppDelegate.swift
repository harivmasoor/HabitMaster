import UIKit
import BackgroundTasks

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    let habitListViewModel = HabitListViewModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willTerminateNotification, object: nil)
        
        // Register the task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.yourcompany.yourapp.resetHabits", using: nil) { task in
            // This closure is called when your task is run
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        scheduleAppRefresh()
        
        return true
    }

    @objc func saveHabits() {
        habitListViewModel.saveHabits()
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        // Schedule the next refresh
        scheduleAppRefresh()

        // Perform the task
        habitListViewModel.resetHabitsIfNeeded()

        // Mark the task as complete
        task.setTaskCompleted(success: true)
    }

    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.HabitMaster.HabitMaster.resetHabits")
        // Fetch no earlier than 15 minutes from now
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
}
