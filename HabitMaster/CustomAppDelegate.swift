import UIKit
import BackgroundTasks

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    let habitListViewModel = HabitListViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions called")
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveHabits), name: UIApplication.willTerminateNotification, object: nil)
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
        print("Application did finish launching")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application entered background")
        registerBackgroundTasks()
        scheduleAppRefresh()
    }
    
    @objc func saveHabits() {
        print("saveHabits called")
        habitListViewModel.saveHabits()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active")
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("Task started with identifier: \(task.identifier)")
        // Perform the task
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
        // Mark the task as complete
        task.setTaskCompleted(success: true)
        print("Task completed with identifier: \(task.identifier)")
        // Schedule the next refresh
        scheduleAppRefresh()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.HabitMaster.HabitMaster.HabitMaster.resetHabits")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Fetch no earlier than 1 minutes from now
        
        do {
            BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: "com.HabitMaster.HabitMaster.HabitMaster.resetHabits")
            try BGTaskScheduler.shared.submit(request)
            print("App refresh scheduled with identifier: \(request.identifier) and earliestBeginDate: \(String(describing: request.earliestBeginDate))")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func registerBackgroundTasks() {
        // Register the task
        let result = BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.HabitMaster.HabitMaster.HabitMaster.resetHabits", using: nil) { task in
            // This closure is called when your task is run
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        if result {
            print("Task registered with identifier: com.HabitMaster.HabitMaster.HabitMaster.resetHabits")
        } else {
            print("Failed to register task")
        }
        
        // Check for pending tasks
        BGTaskScheduler.shared.getPendingTaskRequests { (requests) in
            for request in requests {
                print("Pending task: \(request.identifier) with earliestBeginDate: \(String(describing: request.earliestBeginDate))")
            }
        }
    }
}

