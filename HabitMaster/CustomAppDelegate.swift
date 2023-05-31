import UIKit
import BackgroundTasks

class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    let habitListViewModel = HabitListViewModel()
    let stepCountViewModel = StepCountViewModel()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions called")
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willTerminateNotification, object: nil)
//        stepCountViewModel.loadStepCounts()
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
        stepCountViewModel.saveStepCounts()
        print("Application did finish launching")
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application entered background")
        registerBackgroundTasks()
        scheduleAppRefresh()
    }
    
    @objc func saveData() {
        print("saveData called")
        do {
            let data = try JSONEncoder().encode(stepCountViewModel.stepCounts)
            print("Encoded data: \(data)")
            UserDefaults.standard.set(data, forKey: "stepCounts")
        } catch {
            print("Failed to encode stepCounts: \(error)")
        }
        habitListViewModel.saveHabits()
        stepCountViewModel.saveStepCounts()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("App became active")
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
        saveData()
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("Task started with identifier: \(task.identifier)")
        // Perform the task
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
//        stepCountViewModel.loadStepCounts()
        saveData()
//        loadData()
        // Mark the task as complete
        task.setTaskCompleted(success: true)
        print("Task completed with identifier: \(task.identifier)")
        // Schedule the next refresh
        scheduleAppRefresh()
    }
    func handleSaveStepCounts(task: BGProcessingTask) {
        task.expirationHandler = {
            // Handle task expiration if needed
        }
        
        saveData()
        
        task.setTaskCompleted(success: true)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        habitListViewModel.resetStreaksIfNeeded()
        habitListViewModel.saveHabits()
//        stepCountViewModel.loadStepCounts()
        saveData()
//        loadData()
    }
    
    func scheduleAppRefresh() {
        let request = BGProcessingTaskRequest(identifier: "com.HabitMaster.HabitMaster.HabitMaster.saveStepCounts")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("App refresh scheduled with identifier: \(request.identifier)")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }

    
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.HabitMaster.HabitMaster.HabitMaster.saveStepCounts", using: nil) { task in
            self.handleSaveStepCounts(task: task as! BGProcessingTask)
        }
    }

    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "stepCounts") {
            print("Retrieved data: \(data)")
            do {
                let decodedStepCounts = try JSONDecoder().decode([StepCount].self, from: data)
                print("Decoded stepCounts: \(decodedStepCounts)")
                self.stepCountViewModel.stepCounts = decodedStepCounts
            } catch {
                print("Failed to decode stepCounts: \(error)")
            }
        }
    }
    
}
